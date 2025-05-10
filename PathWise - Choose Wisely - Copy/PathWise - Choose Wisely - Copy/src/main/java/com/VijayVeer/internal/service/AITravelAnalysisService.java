package com.VijayVeer.internal.service;

import com.VijayVeer.internal.model.ChatRequest;
import com.VijayVeer.internal.model.SustainableTrip;
import com.VijayVeer.internal.model.TravelOption;
import com.VijayVeer.internal.repository.SustainableTripRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.text.DecimalFormat;

@Service
public class AITravelAnalysisService {

    @Autowired
    private RestTemplate restTemplate;
    
    @Autowired
    private SustainableTripRepository sustainableTripRepository;
    
    @Value("${gemini.api.key}")
    private String apiKey;
    
    @Value("${gemini.api.url}")
    private String apiUrl;
    
    private static final DecimalFormat df = new DecimalFormat("0.00");
    
    public SustainableTrip analyzeAndRecommendOptions(Long tripId) {
        SustainableTrip trip = sustainableTripRepository.findById(tripId)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + tripId));
        
        if (trip.getTravelOptions() == null || trip.getTravelOptions().isEmpty()) {
            throw new RuntimeException("No travel options available for analysis");
        }
        
        // Build prompt for Gemini
        String prompt = buildPromptForAnalysis(trip);
        
        // Call Gemini API
        Map<String, Object> response = callGeminiAPI(prompt);
        
        if (response != null && response.containsKey("candidates")) {
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) response.get("candidates");
            if (!candidates.isEmpty()) {
                Map<String, Object> firstCandidate = candidates.get(0);
                Map<String, Object> content = (Map<String, Object>) firstCandidate.get("content");
                List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
                String analysisText = (String) parts.get(0).get("text");
                
                // Extract recommendation and analysis
                Map<String, String> parsedAnalysis = parseAnalysisText(analysisText);
                
                trip.setAiRecommendation(parsedAnalysis.get("recommendation"));
                trip.setAiAnalysis(parsedAnalysis.get("analysis"));
                
                return sustainableTripRepository.save(trip);
            }
        }
        
        throw new RuntimeException("Failed to get AI analysis");
    }
    
    private String buildPromptForAnalysis(SustainableTrip trip) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("As an AI assistant specializing in sustainable mobility planning, analyze the following travel options ");
        prompt.append("from ").append(trip.getOrigin()).append(" to ").append(trip.getDestination());
        prompt.append(" based on the user's preference for ").append(trip.getUserPreference()).append(":\n\n");
        
        // Add details for each option
        for (TravelOption option : trip.getTravelOptions()) {
            prompt.append("TRANSPORTATION MODE: ").append(option.getTransportMode()).append("\n");
            prompt.append("- Distance: ").append(df.format(option.getDistance() / 1000)).append(" km\n");
            prompt.append("- Duration: ").append(formatDuration(option.getDuration())).append("\n");
            prompt.append("- Cost: ₹").append(df.format(option.getCost())).append("\n");
            prompt.append("- CO2 Emission: ").append(df.format(option.getCo2Emission())).append(" g\n\n");
        }
        
        prompt.append("Based on this data and the user's preference for ").append(trip.getUserPreference());
        prompt.append(", provide your analysis and recommendation in the following format:\n\n");
        prompt.append("RECOMMENDATION: [Provide a one-sentence recommendation for the most practical and sustainable transport mode based on the user's preference. ");
        prompt.append("Take distance into account — recommend walking only if the distance is up to 2.5 km, cycling if the distance is moderate (up to 8 km), and consider other transport modes if the distance is long. ");
        prompt.append("Ensure that the recommendation aligns with the user's preference, but is also realistic and feasible.]\n\n");

        prompt.append("ANALYSIS: [Provide a detailed analysis of all options, comparing their pros and cons, and explaining why the recommended option is best for the user's preference. Include data-driven insights about time, cost, and environmental impact.]");
        prompt.append("Justify the final recommendation based on a combination of practicality and the user's stated priority (e.g., cheapest, fastest, greenest, balanced). If trade-offs are involved, clearly explain them.]\n\n");

        // Guidelines for different preferences
        prompt.append("Consider these priority factors for different preferences:\n");
        prompt.append("- FASTEST: Prioritize duration first, but mention if there are options that are almost as fast but much better in other aspects.\n");
        prompt.append("- CHEAPEST: Prioritize cost first, but consider if spending slightly more would save significant time or emissions.\n");
        prompt.append("- GREENEST: Prioritize low CO2 emissions first, but balance with practicality of time and cost.\n");
        prompt.append("- BALANCED: Consider a weighted average of all factors, finding the most reasonable overall option.\n");
        
        return prompt.toString();
    }
    
    private String formatDuration(double seconds) {
        long totalMinutes = Math.round(seconds / 60);
        long hours = totalMinutes / 60;
        long minutes = totalMinutes % 60;
        
        if (hours > 0) {
            return hours + " hr " + minutes + " min";
        } else {
            return minutes + " min";
        }
    }
    
    private Map<String, Object> callGeminiAPI(String prompt) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + apiKey);
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        // Create request body following OpenRouter API format
        List<Map<String, Object>> messages = new ArrayList<>();
        Map<String, Object> message = new HashMap<>();
        message.put("role", "user");
        message.put("content", prompt);
        messages.add(message);
        
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "google/gemini-pro");
        requestBody.put("messages", messages);
        
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
        
        try {
            Map<String, Object> response = restTemplate.postForObject(apiUrl, entity, Map.class);
            
            // Transform OpenRouter response to match expected format
            if (response != null && response.containsKey("choices") && ((List<?>) response.get("choices")).size() > 0) {
                Map<String, Object> transformedResponse = new HashMap<>();
                
                Map<String, Object> firstChoice = (Map<String, Object>) ((List<?>) response.get("choices")).get(0);
                Map<String, Object> choiceMessage = (Map<String, Object>) firstChoice.get("message");
                String content = (String) choiceMessage.get("content");
                
                // Create a structure similar to what we expect from Gemini API
                List<Map<String, Object>> candidates = new ArrayList<>();
                Map<String, Object> candidate = new HashMap<>();
                Map<String, Object> candidateContent = new HashMap<>();
                List<Map<String, Object>> parts = new ArrayList<>();
                Map<String, Object> part = new HashMap<>();
                part.put("text", content);
                parts.add(part);
                candidateContent.put("parts", parts);
                candidate.put("content", candidateContent);
                candidates.add(candidate);
                
                transformedResponse.put("candidates", candidates);
                return transformedResponse;
            }
            
            return null;
        } catch (Exception e) {
            System.err.println("Error calling AI API: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    private Map<String, String> parseAnalysisText(String text) {
        Map<String, String> result = new HashMap<>();
        
        // Extract recommendation (assuming it follows the format we requested)
        int recommendationStart = text.indexOf("RECOMMENDATION:") + "RECOMMENDATION:".length();
        int analysisStart = text.indexOf("ANALYSIS:");
        
        if (recommendationStart > 0 && analysisStart > recommendationStart) {
            String recommendation = text.substring(recommendationStart, analysisStart).trim();
            String analysis = text.substring(analysisStart + "ANALYSIS:".length()).trim();
            
            result.put("recommendation", recommendation);
            result.put("analysis", analysis);
        } else {
            // Fallback if format isn't exactly as expected
            result.put("recommendation", "Based on your preference, the AI recommends reviewing the provided options carefully.");
            result.put("analysis", text);
        }
        
        return result;
    }
    
    public SustainableTrip updatePreferenceAndReanalyze(Long tripId, String newPreference) {
        SustainableTrip trip = sustainableTripRepository.findById(tripId)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + tripId));
        
        // Update preference
        trip.setUserPreference(newPreference);
        sustainableTripRepository.save(trip);
        
        // Rerun analysis
        return analyzeAndRecommendOptions(tripId);
    }
} 