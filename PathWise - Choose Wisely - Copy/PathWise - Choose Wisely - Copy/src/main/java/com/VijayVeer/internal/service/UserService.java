package com.VijayVeer.internal.service;

import com.VijayVeer.internal.model.User;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.Optional;

public interface UserService extends UserDetailsService {
    User save(User user);
    boolean isUsernameExists(String username);
    boolean isEmailExists(String email);
    Optional<User> findByUsername(String username);
} 