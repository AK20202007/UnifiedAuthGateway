package com.example.springboot_api;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class OrdersController {

    @GetMapping("/orders/info")
    public Map<String, Object> getOrdersInfo(@AuthenticationPrincipal Jwt jwt) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Welcome to the Orders API!");
        // jwt.getSubject() usually contains the user identifier
        response.put("user_id", jwt.getSubject());
        response.put("status", "active");
        response.put("recent_orders", 5);
        return response;
    }
}
