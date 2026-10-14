INSERT INTO produkty (id, nazwa, cena) VALUES
    (1, 'Klawiatura mechaniczna', 349.00),
    (2, 'Mysz bezprzewodowa', 129.00),
    (3, 'Monitor 27 cali', 1199.00)
ON CONFLICT (id) DO NOTHING;
