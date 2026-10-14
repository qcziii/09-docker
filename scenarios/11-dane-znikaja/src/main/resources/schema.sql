CREATE TABLE IF NOT EXISTS zamowienia (
    id      BIGSERIAL PRIMARY KEY,
    produkt VARCHAR(100) NOT NULL,
    ilosc   INT NOT NULL
);
