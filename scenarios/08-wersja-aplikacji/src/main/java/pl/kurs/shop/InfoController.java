package pl.kurs.shop;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @Value("${shop.version}")
    private String version;

    @GetMapping("/api/info")
    Map<String, Object> info() {
        return Map.of("application", "shop", "version", version);
    }
}
