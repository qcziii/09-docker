package pl.kurs.sklep;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/** Przy starcie ładuje cały katalog do pamięci, żeby strona główna nie odpytywała bazy. */
@Component
class KatalogCache implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(KatalogCache.class);

    private final JdbcTemplate jdbc;
    private volatile List<Map<String, Object>> produkty = List.of();

    KatalogCache(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public void run(ApplicationArguments args) {
        produkty = jdbc.queryForList("SELECT id, nazwa, cena FROM produkty ORDER BY id");
        log.info("Załadowano {} produktów do cache katalogu", produkty.size());
    }

    List<Map<String, Object>> produkty() {
        return produkty;
    }
}
