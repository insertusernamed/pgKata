DROP TABLE IF EXISTS raw_data CASCADE;

CREATE TABLE raw_data (
    id SERIAL PRIMARY KEY,
    date_str VARCHAR(50),
    price_str VARCHAR(50),
    phone_str VARCHAR(50)
);

INSERT INTO raw_data (date_str, price_str, phone_str) VALUES
('2024-01-15', '$1,299.99', '2125551234'),
('2024-02-20', '$899.99', '312-555-5678'),
('2024-03-10', '$49.99', '(415) 555-9012'),
('InvalidDate', '$100.00', '5551234567'),
('2024-05-01', 'INVALID', '818.555.3456');
