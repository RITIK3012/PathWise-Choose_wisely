//package com.VijayVeer.internal;
//
//import com.VijayVeer.internal.model.Ride;
//import com.VijayVeer.internal.service.RideService;
//import org.springframework.ai.chat.ChatClient;
//import org.springframework.ai.chat.prompt.Prompt;
//import org.springframework.ai.ollama.OllamaChatClient;
//import org.springframework.ai.ollama.api.OllamaApi;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.http.ResponseEntity;
//import org.springframework.ai.chat.ChatResponse;
//
//import java.sql.SQLOutput;
//
//@Controller
//public class AIController {
//    private static final Logger logger = LoggerFactory.getLogger(AIController.class);
//    private final ChatClient chatClient;
//
//    @Autowired
//    RideService service;
//
//    public AIController(OllamaChatClient chatClient) {
//        this.chatClient = chatClient;
//        logger.info("AIController initialized with OllamaChatClient");
//    }
//
//
//    @GetMapping("/rides/prompt")
//    public ResponseEntity<String> promptResponse(
//            @RequestParam("prompt") String prompt
//    ) {
//        Long rideId = Long.parseLong(prompt);
//        Ride ride = service.getRide(rideId);
//        String rideDetails = ride.toString();
//        System.out.println(ride);
//        String myPrompt = "There is a data of whole ride, having details and a dispute reason analyze the whole data get insights from data that why the customer have that problem?";
//
//        prompt = (myPrompt + rideDetails);
//
//        logger.info("Received prompt request: {}", prompt);
//        try {
//            ChatResponse response = chatClient.call(new Prompt(prompt));
//            String content = response.getResult().getOutput().getContent();
////            String htmlContent = "<html><body style='font-family: Arial; line-height: 1.6;'>" +
////                    "<h2>AI Analysis Report</h2>" +
////                    "<p>" + content.replaceAll("\n", "<br>") + "</p>" +
////                    "</body></html>";
//
//            String htmlContent = "<html>" +
//                    "<head>" +
//                    "<style>" +
//                    ":root {" +
//                    "    --primary-color: #1E3A8A;" +
//                    "    --secondary-color: #22C55E;" +
//                    "    --background-color: #0F172A;" +
//                    "    --text-color: #F8FAFC;" +
//                    "    --card-bg: #1E293B;" +
//                    "    --input-bg: #334155;" +
//                    "    --danger-color: #EF4444;" +
//                    "}" +
//                    "body {" +
//                    "    font-family: Arial, sans-serif;" +
//                    "    line-height: 1.6;" +
//                    "    background-color: var(--background-color);" +
//                    "    color: var(--text-color);" +
//                    "    margin: 0;" +
//                    "    padding: 20px;" +
//                    "}" +
//                    "h2 {" +
//                    "    color: var(--secondary-color);" +
//                    "    border-bottom: 2px solid var(--primary-color);" +
//                    "    padding-bottom: 10px;" +
//                    "    margin-bottom: 20px;" +
//                    "}" +
//                    "p {" +
//                    "    background-color: var(--card-bg);" +
//                    "    padding: 20px;" +
//                    "    border-radius: 8px;" +
//                    "    margin-top: 0;" +
//                    "}" +
//                    "</style>" +
//                    "</head>" +
//                    "<body>" +
//                    "<h2>AI Analysis Report</h2>" +
//                    "<p>" + content.replaceAll("\n", "<br>") + "</p>" +
//                    "</body></html>";
//            logger.info("Successfully got response from Ollama");
//            return ResponseEntity.ok(htmlContent);
//        } catch (Exception e) {
//            logger.error("Error in promptResponse: {}", e.getMessage(), e);
//            return ResponseEntity.internalServerError()
//                    .body("Error processing request: " + e.getMessage());
//        }
//    }
//}