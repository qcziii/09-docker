package pl.kurs.sklep;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    @GetMapping("/api/info")
    Map<String, Object> info() {
        long maxHeapMb = Runtime.getRuntime().maxMemory() / 1024 / 1024;
        return Map.of("aplikacja", "sklep", "maxHeapMb", maxHeapMb);
    }

    /** Raport sprzedaży: na chwilę potrzebuje ok. 64 MB pamięci. */
    @GetMapping("/api/raport")
    Map<String, Object> raport() {
        List<byte[]> dane = new ArrayList<>();
        for (int i = 0; i < 64; i++) {
            byte[] mb = new byte[1024 * 1024];
            mb[0] = (byte) i;
            dane.add(mb);
        }
        return Map.of("raport", "sprzedaz", "przetworzonoMb", dane.size());
    }
}
