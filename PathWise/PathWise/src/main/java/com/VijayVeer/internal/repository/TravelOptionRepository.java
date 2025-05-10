package com.VijayVeer.internal.repository;

import com.VijayVeer.internal.model.TravelOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TravelOptionRepository extends JpaRepository<TravelOption, Long> {
    List<TravelOption> findByTripId(Long tripId);
    TravelOption findByTripIdAndTransportMode(Long tripId, String transportMode);
    TravelOption findByTripIdAndSelected(Long tripId, boolean selected);
} 