package pl.kurs.sklep;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    private final SklepProperties sklep;

    InfoController(SklepProperties sklep) {
        this.sklep = sklep;
    }

    @GetMapping("/api/info")
    Map<String, Object> info() {
        return Map.of("waluta", sklep.waluta(), "rabat", sklep.rabat());
    }

    @GetMapping("/api/products/1")
    Map<String, Object> produkt() {
        BigDecimal cena = new BigDecimal("349.00")
                .multiply(BigDecimal.valueOf(100 - sklep.rabat()))
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        return Map.of("nazwa", "Klawiatura mechaniczna", "cena", cena, "waluta", sklep.waluta());
    }
}
