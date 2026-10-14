package pl.kurs.sklep;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("sklep")
record SklepProperties(String waluta, int rabat) {
}
