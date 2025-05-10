package com.VijayVeer.internal.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {

    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "This is a test page. If you can see this, the application is running correctly.";
    }
    
    @GetMapping("/test-page")
    public String testPage() {
        return "login"; // Just return the login page directly
    }
} 