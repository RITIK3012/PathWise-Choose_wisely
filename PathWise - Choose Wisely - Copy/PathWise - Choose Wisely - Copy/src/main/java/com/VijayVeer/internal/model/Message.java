package com.VijayVeer.internal.model;

import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
public class Message {
    private String role;
    private String content;

    public Message() {}
    public Message(String role, String content) {
        this.role = role;
        this.content = content;
    }
}
