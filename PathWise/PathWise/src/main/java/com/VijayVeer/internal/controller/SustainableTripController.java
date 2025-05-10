package com.VijayVeer.internal.controller;

import com.VijayVeer.internal.model.SustainableTrip;
import com.VijayVeer.internal.model.TravelOption;
import com.VijayVeer.internal.service.AITravelAnalysisService;
import com.VijayVeer.internal.service.SustainableTripService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLOutput;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/sustainable")
public class SustainableTripController {
    
    @Autowired
    private SustainableTripService tripService;
    
    @Autowired
    private AITravelAnalysisService aiService;
    
    @Value("${google.maps.api.key}")
    private String apiKey;
    
    // Home page with trip planning form
    @GetMapping("/")
    public String homePage(Model model) {
        model.addAttribute("apiKey", apiKey);
        return "sustainableHome";
    }
    
    // Create trip and get multi-modal options
    @PostMapping("/plan")
    public String planTrip(@RequestParam String origin,
                          @RequestParam String destination,
                          @RequestParam String name,
                          @RequestParam String preference,
                           @RequestParam String travelType,
                          Model model) {
        try {
            // Create a new trip
            SustainableTrip trip = tripService.createTrip(name, origin, destination, preference, travelType);
            
            // Generate multi-modal options
            trip = tripService.getMultiModalOptions(trip.getId());
            
            // Get AI analysis and recommendation
            trip = aiService.analyzeAndRecommendOptions(trip.getId());
            
            model.addAttribute("apiKey", apiKey);
            model.addAttribute("trip", trip);
            model.addAttribute("travelOptions", trip.getTravelOptions());
            model.addAttribute("recommendation", trip.getAiRecommendation());
            model.addAttribute("analysis", trip.getAiAnalysis());

            System.out.println("Analysis : "+trip.getAiAnalysis());
            
            return "tripOptions";
        } catch (Exception e) {
            model.addAttribute("error", "Error planning trip: " + e.getMessage());
            return "error";
        }
    }
    
    // Update user preference and re-analyze
    @PostMapping("/{id}/update-preference")
    public String updatePreference(@PathVariable("id") Long tripId,
                                  @RequestParam String preference,
                                  Model model) {
        try {
            SustainableTrip trip = aiService.updatePreferenceAndReanalyze(tripId, preference);
            
            model.addAttribute("apiKey", apiKey);
            model.addAttribute("trip", trip);
            model.addAttribute("travelOptions", trip.getTravelOptions());
            model.addAttribute("recommendation", trip.getAiRecommendation());
            model.addAttribute("analysis", trip.getAiAnalysis());
            
            return "tripOptions";
        } catch (Exception e) {
            model.addAttribute("error", "Error updating preference: " + e.getMessage());
            return "error";
        }
    }
    
    // Select travel option
    @PostMapping("/{id}/select-option")
    public String selectOption(@PathVariable("id") Long tripId,
                              @RequestParam String transportMode,
                              Model model) {
        try {
            TravelOption selectedOption = tripService.selectTravelOption(tripId, transportMode);
            SustainableTrip trip = selectedOption.getTrip();
            
            model.addAttribute("apiKey", apiKey);
            model.addAttribute("trip", trip);
            model.addAttribute("selectedOption", selectedOption);
            
            return "tripSimulation";
        } catch (Exception e) {
            model.addAttribute("error", "Error selecting option: " + e.getMessage());
            return "error";
        }
    }
    
    // Simulate ride progress - API endpoint for AJAX calls
    @GetMapping("/{id}/simulate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> simulateTrip(@PathVariable("id") Long tripId) {
        try {
            TravelOption selectedOption = tripService.getSelectedOption(tripId);
            
            if (selectedOption == null) {
                return ResponseEntity.badRequest().build();
            }
            
            // Simple simulation logic (could be enhanced with more complex simulation)
            // This is a placeholder for the actual simulation
            double progress = Math.random(); // 0.0 to 1.0
            double currentDistance = selectedOption.getDistance() * progress;
            double currentDuration = selectedOption.getDuration() * progress;
            double currentCost = selectedOption.getCost() * progress;
            double currentCO2 = selectedOption.getCo2Emission() * progress;
            
            // Create simulation result
            Map<String, Object> result = new HashMap<>();
            result.put("progress", progress);
            result.put("currentDistance", currentDistance);
            result.put("currentDuration", currentDuration);
            result.put("currentCost", currentCost);
            result.put("currentCO2", currentCO2);
            result.put("isComplete", progress >= 1.0);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Complete trip
    @PostMapping("/{optionId}/complete")
    public String completeTrip(@PathVariable("optionId") Long optionId,
                              @RequestParam double actualDistance,
                              @RequestParam double actualDuration,
                              @RequestParam String actualPolyline,
                              Model model) {
        try {
            TravelOption completedOption = tripService.updateTravelOptionWithActualData(
                optionId, actualDistance, actualDuration, actualPolyline);
            
            SustainableTrip trip = completedOption.getTrip();
            
            model.addAttribute("apiKey", apiKey);
            model.addAttribute("trip", trip);
            model.addAttribute("option", completedOption);
            
            // Add comparison metrics
            double distanceDiff = completedOption.getActualDistance() - completedOption.getDistance();
            double durationDiff = completedOption.getActualDuration() - completedOption.getDuration();
            double costDiff = completedOption.getActualCost() - completedOption.getCost();
            double co2Diff = completedOption.getActualCo2Emission() - completedOption.getCo2Emission();
            
            model.addAttribute("distanceDiff", distanceDiff);
            model.addAttribute("durationDiff", durationDiff);
            model.addAttribute("costDiff", costDiff);
            model.addAttribute("co2Diff", co2Diff);


            Date date = Date.from(trip.getCompletedAt().atZone(ZoneId.systemDefault()).toInstant());
            model.addAttribute("date", date);
            
            return "tripComplete";
        } catch (Exception e) {
            model.addAttribute("error", "Error completing trip: " + e.getMessage());
            return "error";
        }
    }
    
    // Get trip history
    @GetMapping("/history")
    public String getTripHistory(Model model) {
        List<SustainableTrip> completedTrips = tripService.getCompletedTrips();
        model.addAttribute("trips", completedTrips);
        System.out.println("In History...");
        return "tripHistory";
    }
    
    // Get user trips
    @GetMapping("/my-trips")
    public String getUserTrips(@RequestParam String userName, Model model) {
        List<SustainableTrip> userTrips = tripService.getUserTrips(userName);
        model.addAttribute("trips", userTrips);
        return "userTrips";
    }
} 