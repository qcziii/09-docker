package pl.kurs.sklep;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class ProductController {

    private final JdbcTemplate jdbc;

    ProductController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/api/products")
    List<Map<String, Object>> all() {
        return jdbc.queryForList("SELECT id, nazwa, cena FROM produkty ORDER BY id");
    }
}
