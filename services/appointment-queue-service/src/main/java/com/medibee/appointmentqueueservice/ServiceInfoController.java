package com.medibee.appointmentqueueservice;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
@RestController
public class ServiceInfoController {
 @GetMapping("/api/v1/appointments/status") public Map<String,String> status() { return Map.of("service","appointment-queue-service","status","UP","stage","bootstrap"); }
}
