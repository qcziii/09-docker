package pl.kurs.sklep;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @GetMapping("/api/info")
    Map<String, Object> info() {
        return Map.of("aplikacja", "sklep", "status", "dziala");
    }
}
