//package com.VijayVeer.internal;
//
//import com.VijayVeer.internal.model.RouteInfo;
//import com.VijayVeer.internal.service.FirstService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//
//@Controller
//public class FirstController {
//    @Autowired
//    FirstService service;
//
//    @Autowired
//    RouteInfo routeInfo;
//
//    @GetMapping("/")
//    public String checking(Model model){
//        String stLoc = "Indore";
//        String des = "Khachroda";
//        RouteInfo routeInfo = service.getRouteData(stLoc, des, model);
//
//        // Add data to model for JSP
//        model.addAttribute("origin", stLoc);
//        model.addAttribute("destination", des);
//        model.addAttribute("distance", routeInfo.getDistance());
//        model.addAttribute("duration", routeInfo.getDuration());
//        model.addAttribute("encodedPolyline", routeInfo.getEncodedPolyline());
//
//        return "routeInfo";
//    }
//}
