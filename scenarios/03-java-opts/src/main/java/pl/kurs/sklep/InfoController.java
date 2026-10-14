package pl.kurs.sklep;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @Value("${sklep.srodowisko}")
    private String srodowisko;

    @GetMapping("/api/info")
    Map<String, Object> info() {
        long maxHeapMb = Runtime.getRuntime().maxMemory() / 1024 / 1024;
        return Map.of("srodowisko", srodowisko, "maxHeapMb", maxHeapMb);
    }
}
