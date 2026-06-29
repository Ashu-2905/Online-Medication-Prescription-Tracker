package com.medtracker.service;

import com.medtracker.dto.AuthRequest;
import com.medtracker.dto.AuthResponse;
import com.medtracker.dto.RegisterRequest;
import com.medtracker.model.User;
import com.medtracker.repository.UserRepository;
import com.medtracker.security.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    public AuthResponse login(AuthRequest authRequest) {
        logger.info("Login attempt for email: {}", authRequest.getEmail());
        
        try {
            // Normalize email to lowercase for consistent comparison
            String normalizedEmail = authRequest.getEmail().toLowerCase().trim();
            
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    normalizedEmail,
                    authRequest.getPassword()
                )
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            User user = (User) authentication.getPrincipal();
            
            logger.info("Authentication successful for user: {}", user.getEmail());
            
            String token = jwtUtil.generateToken(user.getUsername(), user.getRole().name());
            
            return new AuthResponse(
                token,
                user.getRole().name(),
                user.getName(),
                user.getEmail(),
                user.getId()
            );
        } catch (BadCredentialsException e) {
            logger.warn("Invalid credentials for email: {}", authRequest.getEmail());
            throw new BadCredentialsException("Invalid email or password");
        } catch (Exception e) {
            logger.error("Authentication error for email {}: {}", authRequest.getEmail(), e.getMessage());
            throw new RuntimeException("Authentication failed");
        }
    }

    public AuthResponse register(RegisterRequest registerRequest) {
        logger.info("Registration attempt for email: {}", registerRequest.getEmail());
        
        String email = registerRequest.getEmail().trim();
        
        // Check if email already exists (case-insensitive check handled by repository)
        if (userRepository.existsByEmail(email)) {
            logger.warn("Email already exists: {}", email);
            throw new RuntimeException("Email already exists. Please use a different email or try logging in.");
        }

        User user = new User();
        user.setName(registerRequest.getName());
        // Store email in lowercase for consistency
        user.setEmail(email.toLowerCase());
        user.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        user.setRole(registerRequest.getRole());
        user.setPhone(registerRequest.getPhone());
        user.setSpecialty(registerRequest.getSpecialty());
        user.setStatus("Active");
        user.setCreatedAt(java.time.LocalDateTime.now());

        user = userRepository.save(user);
        logger.info("User registered successfully: {}", user.getEmail());
        
        // Don't generate token on registration - user should login separately
        // Return response without token to force login flow
        return new AuthResponse(
            null, // No token on registration
            user.getRole().name(),
            user.getName(),
            user.getEmail(),
            user.getId()
        );
    }

    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof User) {
            return (User) authentication.getPrincipal();
        }
        throw new RuntimeException("User not authenticated");
    }
}
