//package com.VijayVeer.internal.controller;
//
//import com.VijayVeer.internal.model.ChatRequest;
//import com.VijayVeer.internal.model.ChatResponse;
//import com.VijayVeer.internal.model.Message;
//import com.VijayVeer.internal.service.RideService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.http.*;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.client.RestTemplate;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/rides")
//public class ChatController {
//    @Autowired
//    RideService service;
//
//    @Value("${openrouter.api.key}")
//    private String apiKey;
//
//    @GetMapping("/prompt")
//    public ResponseEntity<String> askQuestion(@RequestParam("prompt") String userPrompt) {
//        RestTemplate restTemplate = new RestTemplate();
//
//
//        Long rideId = Long.parseLong(userPrompt);
//        Ride ride = service.getRide(rideId);
//        String rideDetails = ride.toString();
//        System.out.println(ride);
//        String myPrompt = "Here is the complete ride data, including route details, distance, duration, estimated fare, actual fare, and the customer's dispute reason. Analyze the entire data holistically to identify potential causes or patterns behind the customer's concern. Provide meaningful insights, possible discrepancies, and suggest what might have led to the dispute. Your analysis should focus on fare deviations, route mismatches, unusual delays, or any anomalies that could justify the customer's issue.";
//
//        userPrompt = (myPrompt + rideDetails);
//
//
//        String url = "https://openrouter.ai/api/v1/chat/completions";
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Authorization", "Bearer " + apiKey);
//        headers.setContentType(MediaType.APPLICATION_JSON);
//
//        List<Message> messages = List.of(new Message("user", userPrompt));
//        ChatRequest request = new ChatRequest("google/gemini-pro", messages);
//
//        HttpEntity<ChatRequest> entity = new HttpEntity<>(request, headers);
//
//        ResponseEntity<ChatResponse> response = restTemplate.exchange(
//                url, HttpMethod.POST, entity, ChatResponse.class);
//
//
//        String AIResponse = response.getBody().getChoices().get(0).getMessage().getContent();
//
//        AIResponse = "<html>" +
//                "<head>" +
//                "<style>" +
//                ":root {" +
//                "    --primary-color: #1E3A8A;" +
//                "    --secondary-color: #22C55E;" +
//                "    --background-color: #0F172A;" +
//                "    --text-color: #F8FAFC;" +
//                "    --card-bg: #1E293B;" +
//                "    --input-bg: #334155;" +
//                "    --danger-color: #EF4444;" +
//                "}" +
//                "body {" +
//                "    font-family: Arial, sans-serif;" +
//                "    line-height: 1.6;" +
//                "    background-color: var(--background-color);" +
//                "    color: var(--text-color);" +
//                "    margin: 0;" +
//                "    padding: 20px;" +
//                "}" +
//                "h2 {" +
//                "    color: var(--secondary-color);" +
//                "    border-bottom: 2px solid var(--primary-color);" +
//                "    padding-bottom: 10px;" +
//                "    margin-bottom: 20px;" +
//                "}" +
//                "p {" +
//                "    background-color: var(--card-bg);" +
//                "    padding: 20px;" +
//                "    border-radius: 8px;" +
//                "    margin-top: 0;" +
//                "    font-weight: bold;" +
//                "}" +
//                "</style>" +
//                "</head>" +
//                "<body>" +
//                "<h2>AI Analysis Report</h2>" +
//                "<p>" + AIResponse.replaceAll("\n", "<br>") + "</p>" +
//                "</body></html>";
//
//        return ResponseEntity.ok(AIResponse);
//    }
//}
//
