package pl.kurs.shop;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/** Loads the whole catalog into memory at startup so the home page does not query the database. */
@Component
class CatalogCache implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(CatalogCache.class);

    private final JdbcTemplate jdbc;
    private volatile List<Map<String, Object>> products = List.of();

    CatalogCache(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public void run(ApplicationArguments args) {
        products = jdbc.queryForList("SELECT id, name, price FROM products ORDER BY id");
        log.info("Załadowano {} produktów do cache katalogu", products.size());
    }

    List<Map<String, Object>> products() {
        return products;
    }
}
