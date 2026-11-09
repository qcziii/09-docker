package pl.kurs.shop;

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
class InvoiceController {

    @Value("${shop.invoices.directory}")
    private Path directory;

    @PostMapping("/api/invoices/{orderId}")
    @ResponseStatus(HttpStatus.CREATED)
    Map<String, Object> issue(@PathVariable long orderId) throws IOException {
        Files.createDirectories(directory);
        Path file = directory.resolve("invoice-" + orderId + ".txt");
        Files.writeString(file, "Faktura do zamówienia " + orderId + ", data: " + LocalDate.now() + "\n");
        return Map.of("orderId", orderId, "file", file.toString());
    }
}
