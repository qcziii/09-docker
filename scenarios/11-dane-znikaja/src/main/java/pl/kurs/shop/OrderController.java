package pl.kurs.shop;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
class OrderController {

    record NewOrder(String product, int quantity) {
    }

    private final JdbcTemplate jdbc;

    OrderController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/api/orders")
    List<Map<String, Object>> all() {
        return jdbc.queryForList("SELECT id, product, quantity FROM orders ORDER BY id");
    }

    @PostMapping("/api/orders")
    @ResponseStatus(HttpStatus.CREATED)
    Map<String, Object> create(@RequestBody NewOrder z) {
        Long id = jdbc.queryForObject(
                "INSERT INTO orders (product, quantity) VALUES (?, ?) RETURNING id", Long.class, z.product(), z.quantity());
        return Map.of("id", id, "product", z.product(), "quantity", z.quantity());
    }
}
