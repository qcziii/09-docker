package pl.kurs.sklep;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/** Zamówienia czekają w pamięci na wysłanie do magazynu. Przy zamykaniu aplikacji kolejka jest zapisywana. */
@Component
class KolejkaZamowien {

    private static final Logger log = LoggerFactory.getLogger(KolejkaZamowien.class);

    private final List<String> kolejka = new CopyOnWriteArrayList<>();

    void dodaj(String produkt) {
        kolejka.add(produkt);
    }

    int rozmiar() {
        return kolejka.size();
    }

    @PreDestroy
    void zapiszPrzyZamykaniu() {
        // tu byłby zapis do bazy / wysyłka do magazynu
        log.info("Zamykanie: zapisano zamówienia z kolejki ({})", kolejka.size());
    }
}
