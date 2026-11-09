package pl.kurs.shop;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class InfoController {

    private final ShopProperties shop;

    InfoController(ShopProperties shop) {
        this.shop = shop;
    }

    @GetMapping("/api/info")
    Map<String, Object> info() {
        return Map.of("currency", shop.currency(), "discount", shop.discount());
    }

    @GetMapping("/api/products/1")
    Map<String, Object> product() {
        BigDecimal price = new BigDecimal("349.00")
                .multiply(BigDecimal.valueOf(100 - shop.discount()))
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        return Map.of("name", "Klawiatura mechaniczna", "price", price, "currency", shop.currency());
    }
}
