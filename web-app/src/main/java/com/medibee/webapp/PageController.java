package com.medibee.webapp;
import java.time.Duration;
import java.util.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.client.RestClient;
import org.springframework.http.client.JdkClientHttpRequestFactory;
@Controller
public class PageController {
 private final RestClient client;
 public PageController(@Value("${medibee.gateway-url}") String url) {
  var factory=new JdkClientHttpRequestFactory(java.net.http.HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(2)).build());
  factory.setReadTimeout(Duration.ofSeconds(3)); client=RestClient.builder().baseUrl(url).requestFactory(factory).build();
 }
 @GetMapping("/") String home(){ return "public/home"; }
 @GetMapping("/login") String login(){ return "auth/login"; }
 @GetMapping("/register") String register(){ return "auth/register"; }
 @GetMapping("/doctors") String doctors(){ return "public/doctors"; }
 @GetMapping("/system") String system(Model model){
  var services=new LinkedHashMap<String,String>();
  for(String name:List.of("identity","appointments","medical")) {
   try { var result=client.get().uri("/api/v1/"+name+"/status").retrieve().body(Map.class); services.put(name,result!=null&&"UP".equals(result.get("status"))?"UP":"DOWN"); }
   catch(Exception e){ services.put(name,"UNAVAILABLE"); }
  }
  model.addAttribute("services",services); return "public/system";
 }
}
