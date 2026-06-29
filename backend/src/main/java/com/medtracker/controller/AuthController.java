package com.medtracker.controller;

import com.medtracker.dto.ApiResponse;
import com.medtracker.dto.AuthRequest;
import com.medtracker.dto.AuthResponse;
import com.medtracker.dto.RegisterRequest;
import com.medtracker.service.AuthService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest registerRequest) {
        try {
            logger.info("Registration request received for email: {}", registerRequest.getEmail());
            AuthResponse response = authService.register(registerRequest);
            return ResponseEntity.ok(ApiResponse.success("User registered successfully", response));
        } catch (RuntimeException e) {
            logger.warn("Registration failed for email {}: {}", registerRequest.getEmail(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody AuthRequest authRequest) {
        try {
            logger.info("Login request received for email: {}", authRequest.getEmail());
            AuthResponse response = authService.login(authRequest);
            return ResponseEntity.ok(ApiResponse.success("Login successful", response));
        } catch (BadCredentialsException e) {
            logger.warn("Login failed for email {}: {}", authRequest.getEmail(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        } catch (RuntimeException e) {
            logger.error("Login error for email {}: {}", authRequest.getEmail(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("Authentication failed"));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<Object>> getCurrentUser() {
        try {
            Object user = authService.getCurrentUser();
            return ResponseEntity.ok(ApiResponse.success(user));
        } catch (RuntimeException e) {
            logger.warn("Get current user failed: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
