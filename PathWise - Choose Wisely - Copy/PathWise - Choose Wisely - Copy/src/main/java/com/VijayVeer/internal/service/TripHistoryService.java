package com.VijayVeer.internal.service;

import com.VijayVeer.internal.model.TripHistory;
import com.VijayVeer.internal.model.User;

import java.util.List;
import java.util.Map;

public interface TripHistoryService {
    
    TripHistory saveTrip(TripHistory tripHistory);
    
    List<TripHistory> getUserTripHistory(User user);
    
    long getUserTripCount(User user);
    
    Double getTotalCarbonSavedByUser(User user);
    
    Double getTotalCostSavedByUser(User user);
    
    Map<String, Long> getUserTravelModeStats(User user);
    
    TripHistory getLastTrip(User user);
} 