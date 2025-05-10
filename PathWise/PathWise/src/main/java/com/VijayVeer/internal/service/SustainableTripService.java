package com.VijayVeer.internal.service;

import com.VijayVeer.internal.model.SustainableTrip;
import com.VijayVeer.internal.model.TravelOption;
import com.VijayVeer.internal.repository.SustainableTripRepository;
import com.VijayVeer.internal.repository.TravelOptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SustainableTripService {

    @Autowired
    private SustainableTripRepository sustainableTripRepository;
    
    @Autowired
    private TravelOptionRepository travelOptionRepository;
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Value("${google.maps.api.key}")
    private String apiKey;
    
    // CO2 emission constants (grams per km)
    private static final double WALKING_CO2 = 0.0;
    private static final double CYCLING_CO2 = 0.0;
    private static final double BIKE_CO2 = 100.0;
    private static final double CAR_CO2 = 200.0;
    private static final double BUS_CO2 = 30.0;
    
    // Cost constants (per km)
    private static final double WALKING_COST = 0.0;
    private static final double CYCLING_COST = 0.0;
    private static final double BIKE_COST = 2.5; // e.g. for rented bikes
    private static final double CAR_COST = 6; // Base fare is added separately
    private static final double BUS_COST = 1.3;
    
    // Base fare constants
    private static final double WALKING_BASE_FARE = 0.0;
    private static final double CYCLING_BASE_FARE = 0.0;
    private static final double BIKE_BASE_FARE = 0.0;
    private static final double CAR_BASE_FARE = 20.0;
    private static final double BUS_BASE_FARE = 10.0;
    
    public SustainableTrip createTrip(String userName, String origin, String destination, String preference, String travelType) {
        SustainableTrip trip = new SustainableTrip(userName, origin, destination, preference, travelType);
        return sustainableTripRepository.save(trip);
    }
    
    public SustainableTrip getMultiModalOptions(Long tripId) {
        SustainableTrip trip = sustainableTripRepository.findById(tripId)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + tripId));
        
        // Get coordinates first
        Map<String, Double> coordinates = getCoordinates(trip.getOrigin(), trip.getDestination());
        trip.setOriginLat(coordinates.get("originLat"));
        trip.setOriginLng(coordinates.get("originLng"));
        trip.setDestinationLat(coordinates.get("destinationLat"));
        trip.setDestinationLng(coordinates.get("destinationLng"));
        
        // Generate travel options for different modes
        if(trip.getTravelType().equals("PRIVATE")){
            generateWalkingOption(trip);
            generateCyclingOption(trip);
            generateBikeOption(trip);
            generateCarOption(trip);
        }
        else{
            generateBikeOption(trip);
            generateCarOption(trip);
            generateBusOption(trip);
        }
        
        // Save the trip with all options
        return sustainableTripRepository.save(trip);
    }
    
    private Map<String, Double> getCoordinates(String origin, String destination) {
        Map<String, Double> coordinates = new HashMap<>();
        
        // Build the URL for the Directions API
        String url = String.format(
            "https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&key=%s",
            origin.replace(" ", "+"),
            destination.replace(" ", "+"),
            apiKey
        );
        
        // Call the API and parse the result
        Map<String, Object> result = restTemplate.getForObject(url, Map.class);

        for(Map.Entry<String, Object> entry : result.entrySet()){
            System.out.println("Values : "+entry.getValue());
            System.out.println("Key :"+entry.getKey());
        }
        
        if (result != null && result.containsKey("routes") && !((List<?>) result.get("routes")).isEmpty()) {
            Map<String, Object> route = (Map<String, Object>) ((List<?>) result.get("routes")).get(0);
            List<Map<String, Object>> legs = (List<Map<String, Object>>) route.get("legs");
            Map<String, Object> leg = legs.get(0);
            
            Map<String, Object> startLocation = (Map<String, Object>) leg.get("start_location");
            Map<String, Object> endLocation = (Map<String, Object>) leg.get("end_location");
            
            coordinates.put("originLat", (Double) startLocation.get("lat"));
            coordinates.put("originLng", (Double) startLocation.get("lng"));
            coordinates.put("destinationLat", (Double) endLocation.get("lat"));
            coordinates.put("destinationLng", (Double) endLocation.get("lng"));
        }
        
        return coordinates;
    }
    
    private void generateWalkingOption(SustainableTrip trip) {
        TravelOption option = getRouteForMode(trip, "walking");
        if (option != null) {
            option.setTransportMode("WALKING");
            option.setCo2Emission(WALKING_CO2 * (option.getDistance() / 1000));
            option.setCost(WALKING_COST * (option.getDistance() / 1000) + WALKING_BASE_FARE);
            trip.addTravelOption(option);
        }
    }
    
    private void generateCyclingOption(SustainableTrip trip) {
        TravelOption option = getRouteForMode(trip, "driving");
        if (option != null) {
            option.setTransportMode("CYCLING");
            option.setCo2Emission(CYCLING_CO2 * (option.getDistance() / 1000));
            option.setCost(CYCLING_COST * (option.getDistance() / 1000) + CYCLING_BASE_FARE);
            trip.addTravelOption(option);
        }
    }
    
    private void generateBikeOption(SustainableTrip trip) {
        TravelOption option = getRouteForMode(trip, "driving"); // Reuse bicycling for motorbike with adjusted values
        if (option != null) {
            option.setTransportMode("BIKE");
            option.setCo2Emission(BIKE_CO2 * (option.getDistance() / 1000));
            option.setCost(BIKE_COST * (option.getDistance() / 1000) + BIKE_BASE_FARE);
            // Adjust duration for higher speed of motorbike vs bicycle
            option.setDuration(option.getDuration() * 0.6);
            trip.addTravelOption(option);
        }
    }
    
    private void generateCarOption(SustainableTrip trip) {
        TravelOption option = getRouteForMode(trip, "driving");
        if (option != null) {
            option.setTransportMode("CAR");
            option.setCo2Emission(CAR_CO2 * (option.getDistance() / 1000));
            option.setCost(CAR_COST * (option.getDistance() / 1000) + CAR_BASE_FARE);
            trip.addTravelOption(option);
        }
    }
    
    private void generateBusOption(SustainableTrip trip) {
        TravelOption option = getRouteForMode(trip, "transit");
        if (option != null) {
            option.setTransportMode("BUS");
            option.setCo2Emission(BUS_CO2 * (option.getDistance() / 1000));
            option.setCost(BUS_COST * (option.getDistance() / 1000) + BUS_BASE_FARE);
            trip.addTravelOption(option);
        }
    }
    
    private TravelOption getRouteForMode(SustainableTrip trip, String mode) {
        try {
            // Build the URL for the Directions API
            String url = String.format(
                "https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&mode=%s&key=%s",
                trip.getOrigin().replace(" ", "+"),
                trip.getDestination().replace(" ", "+"),
                mode,
                apiKey
            );
            
            // Call the API and parse the result
            Map<String, Object> result = restTemplate.getForObject(url, Map.class);
            
            if (result != null && result.containsKey("routes") && !((List<?>) result.get("routes")).isEmpty()) {
                Map<String, Object> route = (Map<String, Object>) ((List<?>) result.get("routes")).get(0);
                String encodedPolyline = (String) ((Map<String, Object>) route.get("overview_polyline")).get("points");
                List<Map<String, Object>> legs = (List<Map<String, Object>>) route.get("legs");
                Map<String, Object> leg = legs.get(0);
                
                Map<String, Object> distanceInfo = (Map<String, Object>) leg.get("distance");
                Map<String, Object> durationInfo = (Map<String, Object>) leg.get("duration");
                
                double distance = ((Number) distanceInfo.get("value")).doubleValue();
                double duration = ((Number) durationInfo.get("value")).doubleValue();
                String distanceText = (String) distanceInfo.get("text");
                String durationText = (String) durationInfo.get("text");
                
                TravelOption option = new TravelOption(
                    trip.getOrigin(),
                    trip.getDestination(),
                    mode,
                    distance,
                    duration,
                    0.0, // Will set later
                    0.0, // Will set later
                    encodedPolyline
                );
                
                option.setOriginLat(trip.getOriginLat());
                option.setOriginLng(trip.getOriginLng());
                option.setDestinationLat(trip.getDestinationLat());
                option.setDestinationLng(trip.getDestinationLng());
                
                return option;
            }
        } catch (Exception e) {
            System.err.println("Error generating route for mode " + mode + ": " + e.getMessage());
        }
        
        return null;
    }
    
    public TravelOption selectTravelOption(Long tripId, String transportMode) {
        SustainableTrip trip = sustainableTripRepository.findById(tripId)
                .orElseThrow(() -> new RuntimeException("Trip not found with id: " + tripId));
        
        // Reset all options to not selected
        for (TravelOption option : trip.getTravelOptions()) {
            option.setSelected(false);
        }
        
        // Find and select the chosen option
        TravelOption selectedOption = travelOptionRepository.findByTripIdAndTransportMode(tripId, transportMode);
        if (selectedOption != null) {
            selectedOption.setSelected(true);
            trip.setSelectedMode(transportMode);
            travelOptionRepository.save(selectedOption);
            sustainableTripRepository.save(trip);
            return selectedOption;
        } else {
            throw new RuntimeException("Travel option not found for mode: " + transportMode);
        }
    }
    
    public TravelOption getSelectedOption(Long tripId) {
        return travelOptionRepository.findByTripIdAndSelected(tripId, true);
    }
    
    public TravelOption updateTravelOptionWithActualData(Long optionId, double actualDistance, 
                                                       double actualDuration, String actualPolyline) {
        TravelOption option = travelOptionRepository.findById(optionId)
                .orElseThrow(() -> new RuntimeException("Travel option not found with id: " + optionId));
        
        option.setActualDistance(actualDistance);
        option.setActualDuration(actualDuration);
        
        // Calculate actual cost based on distance and transport mode
        double actualCost = 0.0;
        double actualCo2 = 0.0;
        
        switch(option.getTransportMode()) {
            case "WALKING":
                actualCost = WALKING_COST * (actualDistance / 1000) + WALKING_BASE_FARE;
                actualCo2 = WALKING_CO2 * (actualDistance / 1000);
                break;
            case "CYCLING":
                actualCost = CYCLING_COST * (actualDistance / 1000) + CYCLING_BASE_FARE;
                actualCo2 = CYCLING_CO2 * (actualDistance / 1000);
                break;
            case "BIKE":
                actualCost = BIKE_COST * (actualDistance / 1000) + BIKE_BASE_FARE;
                actualCo2 = BIKE_CO2 * (actualDistance / 1000);
                break;
            case "CAR":
                actualCost = CAR_COST * (actualDistance / 1000) + CAR_BASE_FARE;
                actualCo2 = CAR_CO2 * (actualDistance / 1000);
                break;
            case "BUS":
                actualCost = BUS_COST * (actualDistance / 1000) + BUS_BASE_FARE;
                actualCo2 = BUS_CO2 * (actualDistance / 1000);
                break;
        }
        
        option.setActualCost(actualCost);
        option.setActualCo2Emission(actualCo2);
        
        // Mark the trip as completed
        SustainableTrip trip = option.getTrip();
        trip.setCompleted(true);
        trip.setCompletedAt(LocalDateTime.now());
        sustainableTripRepository.save(trip);
        
        return travelOptionRepository.save(option);
    }
    
    public List<SustainableTrip> getCompletedTrips() {
        return sustainableTripRepository.findByCompletedTrueOrderByCompletedAtDesc();
    }
    
    public List<SustainableTrip> getUserTrips(String userName) {
        return sustainableTripRepository.findByUserNameOrderByCreatedAtDesc(userName);
    }
} 