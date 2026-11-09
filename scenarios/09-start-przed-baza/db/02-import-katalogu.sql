-- Product catalog import. In production the catalog has several hundred thousand items
-- and the import takes about 20 seconds; here we simulate it with pg_sleep.
SELECT pg_sleep(20);

INSERT INTO products (id, name, price) VALUES
    (1, 'Klawiatura mechaniczna', 349.00),
    (2, 'Mysz bezprzewodowa', 129.00),
    (3, 'Monitor 27 cali', 1199.00)
ON CONFLICT (id) DO NOTHING;
