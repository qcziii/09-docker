package pl.kurs.sklep;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
class OrderController {

    private static final Logger log = LoggerFactory.getLogger(OrderController.class);

    private final Map<Long, String> zamowienia = Map.of(
            1L, "Klawiatura mechaniczna",
            2L, "Mysz bezprzewodowa",
            3L, "Monitor 27 cali");

    @GetMapping("/api/orders/{id}")
    ResponseEntity<Map<String, Object>> get(@PathVariable long id) {
        String produkt = zamowienia.get(id);
        if (produkt == null) {
            log.warn("Zamówienie {} nie istnieje", id);
            return ResponseEntity.notFound().build();
        }
        log.info("Pobrano zamówienie {}", id);
        return ResponseEntity.ok(Map.of("id", id, "produkt", produkt));
    }
}
