package pl.kurs.shop;

import java.util.Map;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** Payment gateway simulation: accepts only keys in the format sk_test_... / sk_live_... */
@RestController
class PaymentController {

    private static final Logger log = LoggerFactory.getLogger(PaymentController.class);
    private static final Pattern KEY_FORMAT = Pattern.compile("sk_(test|live)_[A-Za-z0-9_]+");

    private final PaymentGatewayProperties paymentGateway;

    PaymentController(PaymentGatewayProperties paymentGateway) {
        this.paymentGateway = paymentGateway;
    }

    @PostMapping("/api/payments")
    ResponseEntity<Map<String, Object>> pay(@RequestParam long orderId) {
        String key = paymentGateway.apiKey();
        if (key == null || key.isBlank()) {
            log.error("Brak klucza API bramki płatności (shop.payment-gateway.api-key)");
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(Map.of("error", "Brak klucza API bramki"));
        }
        if (!KEY_FORMAT.matcher(key).matches()) {
            log.warn("Bramka {} odrzuciła klucz API (HTTP 401 invalid_api_key). Klucz ma {} znaków i zaczyna się od '{}'",
                    paymentGateway.url(), key.length(), key.substring(0, Math.min(3, key.length())));
            return ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(Map.of("error", "Bramka płatności odrzuciła klucz API"));
        }
        log.info("Płatność za zamówienie {} przyjęta", orderId);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("orderId", orderId, "status", "ACCEPTED"));
    }
}
