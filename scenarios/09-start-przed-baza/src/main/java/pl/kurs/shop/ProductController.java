package pl.kurs.shop;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class ProductController {

    private final CatalogCache catalog;

    ProductController(CatalogCache catalog) {
        this.catalog = catalog;
    }

    @GetMapping("/api/products")
    List<Map<String, Object>> all() {
        return catalog.products();
    }
}
