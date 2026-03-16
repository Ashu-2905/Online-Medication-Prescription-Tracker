package com.medtracker.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.HashMap;

@Service
public class AiChatService {

    private static final Logger logger = LoggerFactory.getLogger(AiChatService.class);

    private final WebClient webClient;
    private final String groqApiKey;
    private boolean useExternalApi = false;

    public AiChatService(@Value("${groq.api.key:}") String groqApiKey) {
        this.groqApiKey = groqApiKey;
        this.useExternalApi = groqApiKey != null && !groqApiKey.trim().isEmpty();
        
        logger.info("Initializing AiChatService with API key: {}", useExternalApi ? "Present" : "Missing (using fallback responses)");
        
        if (useExternalApi) {
            this.webClient = WebClient.builder()
                    .baseUrl("https://api.groq.com/openai/v1")
                    .defaultHeader("Authorization", "Bearer " + groqApiKey)
                    .defaultHeader("Content-Type", "application/json")
                    .build();
        } else {
            this.webClient = null;
        }
    }

    public Mono<String> getChatResponse(String userMessage) {
        logger.info("Processing chat request: {}", userMessage);
        
        // If no API key configured, use fallback responses
        if (!useExternalApi) {
            return Mono.just(getFallbackResponse(userMessage));
        }

        // Create request body for Groq API
        Map<String, Object> requestBody = Map.of(
                "model", "llama-3.1-8b-instant",
                "messages", new Object[]{
                        Map.of(
                                "role", "system",
                                "content", "You are a pharmacy assistant for an online medication website. Provide helpful information about medicines, symptoms, and usage, but always advise users to consult a doctor before taking medication."
                        ),
                        Map.of(
                                "role", "user",
                                "content", userMessage
                        )
                }
        );

        logger.info("Sending request to Groq API");

        return webClient.post()
                .uri("/chat/completions")
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(Map.class)
                .map(response -> {
                    logger.info("Received response from Groq: {}", response);
                    try {
                        // Extract AI message content from response
                        java.util.List<Map<String, Object>> choices = (java.util.List<Map<String, Object>>) response.get("choices");
                        if (choices != null && !choices.isEmpty()) {
                            Map<String, Object> firstChoice = choices.get(0);
                            Map<String, Object> message = (Map<String, Object>) firstChoice.get("message");
                            String content = (String) message.get("content");
                            logger.info("Extracted AI response: {}", content);
                            return content;
                        }
                        logger.warn("No choices found in response");
                        return getFallbackResponse(userMessage);
                    } catch (Exception e) {
                        logger.error("Error parsing Groq response: {}", e.getMessage(), e);
                        return getFallbackResponse(userMessage);
                    }
                })
                .doOnError(error -> {
                    logger.error("Error calling Groq API: {}", error.getMessage(), error);
                })
                .onErrorReturn(getFallbackResponse(userMessage));
    }
    
    private String getFallbackResponse(String userMessage) {
        String lowerMessage = userMessage.toLowerCase();
        
        // Medication-related responses
        if (lowerMessage.contains("paracetamol") || lowerMessage.contains("acetaminophen")) {
            return "Paracetamol (acetaminophen) is a common pain reliever and fever reducer. " +
                   "The usual adult dose is 500-1000mg every 4-6 hours, not exceeding 4000mg per day. " +
                   "Always follow the dosage instructions on the package and consult your doctor if you have liver problems or are taking other medications.";
        }
        
        if (lowerMessage.contains("ibuprofen")) {
            return "Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) used for pain, fever, and inflammation. " +
                   "The typical adult dose is 200-400mg every 4-6 hours as needed. " +
                   "Take with food to reduce stomach upset and consult your doctor if you have stomach issues, kidney problems, or are taking blood thinners.";
        }
        
        if (lowerMessage.contains("headache")) {
            return "For mild headaches, over-the-counter pain relievers like paracetamol or ibuprofen may help. " +
                   "Ensure you're hydrated and well-rested. If headaches are severe, frequent, or accompanied by other symptoms, " +
                   "please consult a healthcare provider for proper diagnosis and treatment.";
        }
        
        if (lowerMessage.contains("fever")) {
            return "Fever is your body's natural response to infection. For adults, paracetamol or ibuprofen can help reduce fever. " +
                   "Stay hydrated and rest. Seek medical attention if fever exceeds 103°F (39.4°C), lasts more than 3 days, or is accompanied by severe symptoms.";
        }
        
        if (lowerMessage.contains("cold") || lowerMessage.contains("flu")) {
            return "For colds and flu, rest and hydration are key. Over-the-counter medications may help with symptoms. " +
                   "Consider paracetamol for fever and pain, and decongestants for nasal congestion. " +
                   "Consult a doctor if symptoms worsen or persist beyond 7-10 days.";
        }
        
        if (lowerMessage.contains("dosage") || lowerMessage.contains("dose")) {
            return "Dosage instructions vary by medication, age, weight, and medical condition. " +
                   "Always follow the dosage on the medication label or as prescribed by your healthcare provider. " +
                   "Never exceed the recommended dose without medical supervision.";
        }
        
        if (lowerMessage.contains("side effect")) {
            return "All medications can cause side effects. Common ones include drowsiness, nausea, or allergic reactions. " +
                   "Read the medication leaflet for complete side effect information. " +
                   "Contact your doctor if you experience severe or persistent side effects.";
        }
        
        if (lowerMessage.contains("pregnant") || lowerMessage.contains("pregnancy")) {
            return "Medication use during pregnancy requires careful consideration. " +
                   "Always consult your healthcare provider before taking any medication while pregnant or breastfeeding, " +
                   "as some medications may not be safe for your baby.";
        }
        
        // Default response
        return "I'm here to provide general information about medications and health topics. " +
               "While I can offer basic guidance, remember that I'm not a substitute for professional medical advice. " +
               "Always consult with your healthcare provider for personalized medical recommendations, " +
               "especially for specific conditions, medications, or treatment plans. " +
               "Is there a specific medication or health topic you'd like to know more about?";
    }
}
