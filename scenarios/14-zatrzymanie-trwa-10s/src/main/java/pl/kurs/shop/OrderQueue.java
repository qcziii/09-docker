package pl.kurs.shop;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/** Orders wait in memory to be sent to the warehouse. The queue is saved when the application shuts down. */
@Component
class OrderQueue {

    private static final Logger log = LoggerFactory.getLogger(OrderQueue.class);

    private final List<String> queue = new CopyOnWriteArrayList<>();

    void add(String product) {
        queue.add(product);
    }

    int size() {
        return queue.size();
    }

    @PreDestroy
    void saveOnShutdown() {
        // here we would save to the database / send to the warehouse
        log.info("Zamykanie: zapisano zamówienia z kolejki ({})", queue.size());
    }
}
