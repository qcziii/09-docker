package pl.kurs.sklep;

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

    record NoweZamowienie(String produkt, int ilosc) {
    }

    private final JdbcTemplate jdbc;

    OrderController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/api/orders")
    List<Map<String, Object>> all() {
        return jdbc.queryForList("SELECT id, produkt, ilosc FROM zamowienia ORDER BY id");
    }

    @PostMapping("/api/orders")
    @ResponseStatus(HttpStatus.CREATED)
    Map<String, Object> create(@RequestBody NoweZamowienie z) {
        Long id = jdbc.queryForObject(
                "INSERT INTO zamowienia (produkt, ilosc) VALUES (?, ?) RETURNING id", Long.class, z.produkt(), z.ilosc());
        return Map.of("id", id, "produkt", z.produkt(), "ilosc", z.ilosc());
    }
}
