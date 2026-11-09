package pl.kurs.shop;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
class OrderController {

    private final OrderQueue queue;

    OrderController(OrderQueue queue) {
        this.queue = queue;
    }

    @PostMapping("/api/orders")
    @ResponseStatus(HttpStatus.ACCEPTED)
    Map<String, Object> placeOrder(@RequestParam String product) {
        queue.add(product);
        return Map.of("product", product, "inQueue", queue.size());
    }
}
