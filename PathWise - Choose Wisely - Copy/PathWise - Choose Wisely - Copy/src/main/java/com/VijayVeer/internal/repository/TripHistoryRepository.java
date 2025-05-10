package com.VijayVeer.internal.repository;

import com.VijayVeer.internal.model.TripHistory;
import com.VijayVeer.internal.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TripHistoryRepository extends JpaRepository<TripHistory, Long> {
    
    List<TripHistory> findByUserOrderByTripDateDesc(User user);
    
    long countByUser(User user);
    
    @Query("SELECT SUM(t.carbonSavedKg) FROM TripHistory t WHERE t.user = :user")
    Double getTotalCarbonSavedByUser(@Param("user") User user);
    
    @Query("SELECT SUM(t.costSaved) FROM TripHistory t WHERE t.user = :user")
    Double getTotalCostSavedByUser(@Param("user") User user);
    
    @Query("SELECT t.travelMode, COUNT(t) FROM TripHistory t WHERE t.user = :user GROUP BY t.travelMode")
    List<Object[]> getModeUsageStatsByUser(@Param("user") User user);
} 