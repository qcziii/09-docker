package pl.kurs.sklep;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class ProductController {

    private final KatalogCache katalog;

    ProductController(KatalogCache katalog) {
        this.katalog = katalog;
    }

    @GetMapping("/api/products")
    List<Map<String, Object>> all() {
        return katalog.produkty();
    }
}
