package pl.kurs.shop;

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
        return Map.of("application", "shop", "maxHeapMb", maxHeapMb);
    }

    /** Sales report: briefly needs about 64 MB of memory. */
    @GetMapping("/api/report")
    Map<String, Object> report() {
        List<byte[]> data = new ArrayList<>();
        for (int i = 0; i < 64; i++) {
            byte[] mb = new byte[1024 * 1024];
            mb[0] = (byte) i;
            data.add(mb);
        }
        return Map.of("report", "sales", "processedMb", data.size());
    }
}
