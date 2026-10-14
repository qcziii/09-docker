package pl.kurs.sklep;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class SklepApplication {

    public static void main(String[] args) {
        SpringApplication.run(SklepApplication.class, args);
    }
}
