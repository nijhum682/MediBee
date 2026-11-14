package com.medibee.patientmedicalservice;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
@RestController
public class ServiceInfoController {
 @GetMapping("/api/v1/medical/status") public Map<String,String> status() { return Map.of("service","patient-medical-service","status","UP","stage","bootstrap"); }
}
