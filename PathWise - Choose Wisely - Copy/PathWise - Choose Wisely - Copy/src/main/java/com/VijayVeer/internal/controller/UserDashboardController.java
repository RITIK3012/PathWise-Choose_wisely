package com.VijayVeer.internal.controller;

import com.VijayVeer.internal.model.TripHistory;
import com.VijayVeer.internal.model.User;
import com.VijayVeer.internal.service.TripHistoryService;
import com.VijayVeer.internal.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/user")
public class UserDashboardController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private TripHistoryService tripHistoryService;
    
    @Value("${google.maps.api.key}")
    private String apiKey;
    
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        // Get trip statistics
        long tripCount = tripHistoryService.getUserTripCount(currentUser);
        Double totalCarbonSaved = tripHistoryService.getTotalCarbonSavedByUser(currentUser);
        Double totalCostSaved = tripHistoryService.getTotalCostSavedByUser(currentUser);
        Map<String, Long> modeStats = tripHistoryService.getUserTravelModeStats(currentUser);
        
        // Add data to model
        model.addAttribute("user", currentUser);
        model.addAttribute("tripCount", tripCount);
        model.addAttribute("totalCarbonSaved", totalCarbonSaved);
        model.addAttribute("totalCostSaved", totalCostSaved);
        model.addAttribute("modeStats", modeStats);
        model.addAttribute("apiKey", apiKey);
        
        return "userDashboard";
    }
    
    @GetMapping("/trip-history")
    public String tripHistory(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        List<TripHistory> trips = tripHistoryService.getUserTripHistory(currentUser);
        
        model.addAttribute("user", currentUser);
        model.addAttribute("trips", trips);
        model.addAttribute("apiKey", apiKey);
        
        return "tripHistory";
    }
    
    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        
        String username = auth.getName();
        Optional<User> userOpt = userService.findByUsername(username);
        return userOpt.orElse(null);
    }
} 