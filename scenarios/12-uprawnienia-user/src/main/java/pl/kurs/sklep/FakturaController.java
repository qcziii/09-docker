package pl.kurs.sklep;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
class FakturaController {

    @Value("${sklep.faktury.katalog}")
    private Path katalog;

    @PostMapping("/api/faktury/{zamowienie}")
    @ResponseStatus(HttpStatus.CREATED)
    Map<String, Object> wystaw(@PathVariable long zamowienie) throws IOException {
        Files.createDirectories(katalog);
        Path plik = katalog.resolve("faktura-" + zamowienie + ".txt");
        Files.writeString(plik, "Faktura do zamówienia " + zamowienie + ", data: " + LocalDate.now() + "\n");
        return Map.of("zamowienie", zamowienie, "plik", plik.toString());
    }
}
