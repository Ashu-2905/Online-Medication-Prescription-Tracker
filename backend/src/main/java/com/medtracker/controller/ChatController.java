package com.medtracker.controller;

import com.medtracker.dto.ApiResponse;
import com.medtracker.service.AiChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000", "http://localhost:5174"})
public class ChatController {

    @Autowired
    private AiChatService aiChatService;

    @PostMapping("/chat")
    public Mono<ResponseEntity<ApiResponse<String>>> chat(@RequestBody Map<String, String> request) {
        String message = request.get("message");
        
        if (message == null || message.trim().isEmpty()) {
            return Mono.just(ResponseEntity.badRequest()
                    .body(ApiResponse.error("Message cannot be empty")));
        }

        return aiChatService.getChatResponse(message)
                .map(reply -> ResponseEntity.ok(ApiResponse.success(reply)))
                .onErrorReturn(ResponseEntity.badRequest()
                        .body(ApiResponse.error("Failed to process chat request")));
    }

    @GetMapping("/chat/health")
    public ResponseEntity<ApiResponse<String>> health() {
        return ResponseEntity.ok(ApiResponse.success("Chat service is running"));
    }
}
