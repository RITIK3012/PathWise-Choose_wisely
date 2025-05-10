package com.VijayVeer.internal.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "login";
    }
    
    @GetMapping("/home")
    public String homePage() {
        return "sustainableHome";
    }
    
    @GetMapping("/sustainableHome")
    public String sustainableHome() {
        return "sustainableHome";
    }
} 