package com.medtracker.security;

import com.medtracker.repository.UserRepository;
import com.medtracker.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        logger.info("=== LOAD USER BY USERNAME ===");
        logger.info("Input email: {}", email);
        
        // Try exact match first (since AuthService normalizes to lowercase)
        String normalizedEmail = email.toLowerCase().trim();
        logger.info("Normalized email for lookup: {}", normalizedEmail);
        
        try {
            // First try exact match with normalized email
            Optional<User> userOptional = userRepository.findByEmailNormalized(normalizedEmail);
            logger.info("Exact match result: {}", userOptional.isPresent());
            
            User user = userOptional.orElse(null);
            
            if (user != null) {
                logger.info("Successfully loaded user via exact match: {}", user.getEmail());
                logger.info("User password hash: {}", user.getPassword());
                logger.info("User role: {}", user.getRole());
                logger.info("User enabled: {}", user.isEnabled());
                return user;
            }
            
            // Fallback to case-insensitive search for existing users with different case
            logger.info("Exact match failed, trying case-insensitive search for: {}", email);
            userOptional = userRepository.findByEmailCaseInsensitive(email);
            logger.info("Case-insensitive match result: {}", userOptional.isPresent());
            
            user = userOptional.orElseThrow(() -> {
                logger.warn("User not found with email: {} (tried exact and case-insensitive)", email);
                return new UsernameNotFoundException("User not found with email: " + email);
            });
            
            logger.info("Successfully loaded user via case-insensitive match: {}", user.getEmail());
            logger.info("User password hash: {}", user.getPassword());
            logger.info("User role: {}", user.getRole());
            logger.info("User enabled: {}", user.isEnabled());
            return user;
            
        } catch (Exception e) {
            logger.error("Error loading user: {}", e.getMessage(), e);
            throw new UsernameNotFoundException("User not found with email: " + email);
        }
    }
}
