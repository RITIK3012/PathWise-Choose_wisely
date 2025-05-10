package com.VijayVeer.internal.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "trip_history")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TripHistory {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(nullable = false)
    private String origin;
    
    @Column(nullable = false)
    private String destination;
    
    @Column(name = "trip_date", nullable = false)
    private LocalDateTime tripDate;
    
    @Column(name = "travel_mode", nullable = false)
    private String travelMode;
    
    @Column(name = "distance_km")
    private Double distanceKm;
    
    @Column(name = "carbon_saved_kg")
    private Double carbonSavedKg;
    
    @Column(name = "cost_saved")
    private Double costSaved;
    
    @Column(name = "trip_duration_minutes")
    private Integer tripDurationMinutes;
} 