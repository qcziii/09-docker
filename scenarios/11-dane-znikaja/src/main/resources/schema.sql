CREATE TABLE IF NOT EXISTS orders (
    id       BIGSERIAL PRIMARY KEY,
    product  VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);
