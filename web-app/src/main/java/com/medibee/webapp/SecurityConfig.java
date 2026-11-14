package com.medibee.webapp;
import org.springframework.context.annotation.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
@Configuration
public class SecurityConfig {
 @Bean SecurityFilterChain security(HttpSecurity http) throws Exception {
  return http.authorizeHttpRequests(a -> a.requestMatchers("/","/about","/login","/register","/doctors","/css/**","/images/**","/actuator/health","/system").permitAll().anyRequest().denyAll()).formLogin(f -> f.disable()).httpBasic(b -> b.disable()).build();
 }
}

