package pl.kurs.sklep;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @Value("${sklep.wersja}")
    private String wersja;

    @GetMapping("/api/info")
    Map<String, Object> info() {
        return Map.of("aplikacja", "sklep", "wersja", wersja);
    }
}
