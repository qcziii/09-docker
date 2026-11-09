package pl.kurs.shop;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @Value("${shop.environment}")
    private String environment;

    @GetMapping("/api/info")
    Map<String, Object> info() {
        long maxHeapMb = Runtime.getRuntime().maxMemory() / 1024 / 1024;
        return Map.of("environment", environment, "maxHeapMb", maxHeapMb);
    }
}
