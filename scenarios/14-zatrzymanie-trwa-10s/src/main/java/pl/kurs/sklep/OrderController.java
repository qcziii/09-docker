package pl.kurs.sklep;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
class OrderController {

    private final KolejkaZamowien kolejka;

    OrderController(KolejkaZamowien kolejka) {
        this.kolejka = kolejka;
    }

    @PostMapping("/api/orders")
    @ResponseStatus(HttpStatus.ACCEPTED)
    Map<String, Object> zamow(@RequestParam String produkt) {
        kolejka.dodaj(produkt);
        return Map.of("produkt", produkt, "wKolejce", kolejka.rozmiar());
    }
}
