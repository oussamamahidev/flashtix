package com.flashtix.booking.api;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/internal/ping")
    public Map<String, String> ping() {
        return Map.of(
            "service", "booking-service",
            "status", "UP"
        );
    }
}
