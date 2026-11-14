package com.medibee.identitystaffservice;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
@RestController
public class ServiceInfoController {
 @GetMapping("/api/v1/identity/status") public Map<String,String> status() { return Map.of("service","identity-staff-service","status","UP","stage","bootstrap"); }
}
