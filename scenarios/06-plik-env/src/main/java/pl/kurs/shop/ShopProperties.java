package pl.kurs.shop;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("shop")
record ShopProperties(String currency, int discount) {
}
