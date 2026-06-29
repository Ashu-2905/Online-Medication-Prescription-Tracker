package com.medtracker.repository;

import com.medtracker.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    // Case-insensitive email lookup with normalization
    default Optional<User> findByEmail(String email) {
        String normalizedEmail = email.toLowerCase().trim();
        return findByEmailNormalized(normalizedEmail);
    }
    
    @Query("{ 'email' : ?0 }")
    Optional<User> findByEmailNormalized(String normalizedEmail);
    
    // Case-insensitive fallback using regex
    @Query("{ 'email' : { $regex: ?0, $options: 'i' } }")
    Optional<User> findByEmailCaseInsensitive(String email);
    
    default boolean existsByEmail(String email) {
        return findByEmail(email).isPresent();
    }
    
    java.util.List<User> findByRole(User.Role role);
}
