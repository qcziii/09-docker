package pl.kurs.sklep;

import java.util.Map;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** Symulacja bramki płatności: przyjmuje tylko klucze w formacie sk_test_... / sk_live_... */
@RestController
class PlatnosciController {

    private static final Logger log = LoggerFactory.getLogger(PlatnosciController.class);
    private static final Pattern FORMAT_KLUCZA = Pattern.compile("sk_(test|live)_[A-Za-z0-9_]+");

    private final BramkaProperties bramka;

    PlatnosciController(BramkaProperties bramka) {
        this.bramka = bramka;
    }

    @PostMapping("/api/platnosci")
    ResponseEntity<Map<String, Object>> zaplac(@RequestParam long zamowienie) {
        String klucz = bramka.apiKey();
        if (klucz == null || klucz.isBlank()) {
            log.error("Brak klucza API bramki płatności (sklep.bramka.api-key)");
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(Map.of("blad", "Brak klucza API bramki"));
        }
        if (!FORMAT_KLUCZA.matcher(klucz).matches()) {
            log.warn("Bramka {} odrzuciła klucz API (HTTP 401 invalid_api_key). Klucz ma {} znaków i zaczyna się od '{}'",
                    bramka.url(), klucz.length(), klucz.substring(0, Math.min(3, klucz.length())));
            return ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(Map.of("blad", "Bramka płatności odrzuciła klucz API"));
        }
        log.info("Płatność za zamówienie {} przyjęta", zamowienie);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("zamowienie", zamowienie, "status", "PRZYJETA"));
    }
}
