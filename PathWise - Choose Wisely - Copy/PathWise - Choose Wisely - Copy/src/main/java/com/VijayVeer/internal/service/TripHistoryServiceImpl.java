package com.VijayVeer.internal.service;

import com.VijayVeer.internal.model.TripHistory;
import com.VijayVeer.internal.model.User;
import com.VijayVeer.internal.repository.TripHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TripHistoryServiceImpl implements TripHistoryService {

    @Autowired
    private TripHistoryRepository tripHistoryRepository;

    @Override
    public TripHistory saveTrip(TripHistory tripHistory) {
        return tripHistoryRepository.save(tripHistory);
    }

    @Override
    public List<TripHistory> getUserTripHistory(User user) {
        return tripHistoryRepository.findByUserOrderByTripDateDesc(user);
    }

    @Override
    public long getUserTripCount(User user) {
        return tripHistoryRepository.countByUser(user);
    }

    @Override
    public Double getTotalCarbonSavedByUser(User user) {
        Double totalSaved = tripHistoryRepository.getTotalCarbonSavedByUser(user);
        return totalSaved != null ? totalSaved : 0.0;
    }

    @Override
    public Double getTotalCostSavedByUser(User user) {
        Double totalSaved = tripHistoryRepository.getTotalCostSavedByUser(user);
        return totalSaved != null ? totalSaved : 0.0;
    }

    @Override
    public Map<String, Long> getUserTravelModeStats(User user) {
        List<Object[]> stats = tripHistoryRepository.getModeUsageStatsByUser(user);
        Map<String, Long> modeStats = new HashMap<>();
        
        for (Object[] stat : stats) {
            String mode = (String) stat[0];
            Long count = ((Number) stat[1]).longValue();
            modeStats.put(mode, count);
        }
        
        return modeStats;
    }

    @Override
    public TripHistory getLastTrip(User user) {
        List<TripHistory> trips = tripHistoryRepository.findByUserOrderByTripDateDesc(user);
        return trips.isEmpty() ? null : trips.get(0);
    }
} 