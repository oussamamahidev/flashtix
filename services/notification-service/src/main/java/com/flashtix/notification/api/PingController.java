package com.flashtix.notification.api;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/internal/ping")
    public Map<String, String> ping() {
        return Map.of(
            "service", "notification-service",
            "status", "UP"
        );
    }
}
