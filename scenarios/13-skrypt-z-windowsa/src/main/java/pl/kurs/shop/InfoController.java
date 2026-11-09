package pl.kurs.shop;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @GetMapping("/api/info")
    Map<String, Object> info() {
        return Map.of("application", "shop", "status", "running");
    }
}
