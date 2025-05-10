package com.VijayVeer.internal.repository;

import com.VijayVeer.internal.model.SustainableTrip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SustainableTripRepository extends JpaRepository<SustainableTrip, Long> {
    List<SustainableTrip> findByCompletedTrueOrderByCompletedAtDesc();
    List<SustainableTrip> findByUserNameOrderByCreatedAtDesc(String userName);
} 