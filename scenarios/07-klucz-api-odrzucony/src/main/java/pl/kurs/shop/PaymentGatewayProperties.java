package pl.kurs.shop;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("shop.payment-gateway")
record PaymentGatewayProperties(String url, String apiKey) {
}
