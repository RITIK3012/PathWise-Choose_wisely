package com.VijayVeer.internal.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "sustainable_trips")
@NoArgsConstructor
@Getter
@Setter
@Component
public class SustainableTrip {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String userName;
    private String origin;
    private String destination;
    private double originLat;
    private double originLng;
    private double destinationLat;
    private double destinationLng;
    
    private String userPreference; // FASTEST, CHEAPEST, GREENEST, BALANCED
    private String travelType; // PRIVATE, PUBLIC
    
    @OneToMany(mappedBy = "trip", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TravelOption> travelOptions = new ArrayList<>();
    
    @Column(columnDefinition = "LONGTEXT")
    private String aiRecommendation;
    
    @Column(columnDefinition = "LONGTEXT")
    private String aiAnalysis;
    
    private String selectedMode;
    
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;
    
    private boolean completed;
    
    public SustainableTrip(String userName, String origin, String destination, String userPreference, String travelType) {
        this.userName = userName;
        this.origin = origin;
        this.destination = destination;
        this.userPreference = userPreference;
        this.travelType = travelType;
        this.createdAt = LocalDateTime.now();
        this.completed = false;
    }
    
    public void addTravelOption(TravelOption option) {
        travelOptions.add(option);
        option.setTrip(this);
    }
} 