package com.VijayVeer.internal.controller;

import com.VijayVeer.internal.model.User;
import com.VijayVeer.internal.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String login(Model model, 
                        @RequestParam(value = "error", required = false) String error,
                        @RequestParam(value = "logout", required = false) String logout) {
        
        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
        }

        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully");
        }
        
        return "login";
    }
    
    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("user", new User());
        return "registration";
    }
    
    @PostMapping("/registration")
    public String registerUser(@ModelAttribute User user, 
                              @RequestParam("confirmPassword") String confirmPassword,
                              Model model, 
                              RedirectAttributes redirectAttributes) {
        
        // Validations
        if (userService.isUsernameExists(user.getUsername())) {
            model.addAttribute("usernameError", "Username already exists");
            return "registration";
        }
        
        if (userService.isEmailExists(user.getEmail())) {
            model.addAttribute("emailError", "Email already exists");
            return "registration";
        }
        
        if (!user.getPassword().equals(confirmPassword)) {
            model.addAttribute("passwordError", "Passwords do not match");
            return "registration";
        }
        
        // All validations passed, save the user
        userService.save(user);
        
        // Redirect to login with success message
        redirectAttributes.addFlashAttribute("successMessage", "Registration successful! Please login.");
        return "redirect:/login";
    }
} 