package pl.kurs.sklep;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("sklep.bramka")
record BramkaProperties(String url, String apiKey) {
}
