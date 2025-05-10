package com.VijayVeer.internal.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Entity
@Table(name = "travel_options")
@NoArgsConstructor
@Getter
@Setter
@Component
public class TravelOption {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String origin;
    private String destination;
    private double originLat;
    private double originLng;
    private double destinationLat;
    private double destinationLng;
    
    private String transportMode; // WALKING, CYCLING, BIKE, CAR, BUS
    
    private double distance; // in meters
    private double duration; // in seconds
    private double cost; // in currency units
    private double co2Emission; // in grams
    
    @Column(columnDefinition = "LONGTEXT")
    private String encodedPolyline;
    
    @ManyToOne
    @JoinColumn(name = "trip_id")
    private SustainableTrip trip;
    
    private boolean selected;
    
    // For actual trip metrics after completion
    private double actualDistance; // in meters
    private double actualDuration; // in seconds
    private double actualCost;
    private double actualCo2Emission;
    
    private LocalDateTime createdAt;
    
    public TravelOption(String origin, String destination, String transportMode,
                      double distance, double duration, double cost, double co2Emission,
                      String encodedPolyline) {
        this.origin = origin;
        this.destination = destination;
        this.transportMode = transportMode;
        this.distance = distance;
        this.duration = duration;
        this.cost = cost;
        this.co2Emission = co2Emission;
        this.encodedPolyline = encodedPolyline;
        this.createdAt = LocalDateTime.now();
        this.selected = false;
    }
} 