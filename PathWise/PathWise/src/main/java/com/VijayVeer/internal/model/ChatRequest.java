package com.VijayVeer.internal.model;

import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Component;

import java.util.List;

@Getter
@Setter
@Component
public class ChatRequest {
    private String model;
    private List<Message> messages;

    public ChatRequest() {}
    public ChatRequest(String model, List<Message> messages) {
        this.model = model;
        this.messages = messages;
    }
}
