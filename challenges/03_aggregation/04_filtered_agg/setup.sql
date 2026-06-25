DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    region VARCHAR(50) NOT NULL
);

INSERT INTO sales (sale_date, amount, region) VALUES
('2024-01-10', 1000.00, 'North'),
('2024-01-15', 1500.00, 'South'),
('2024-01-20', 800.00, 'East'),
('2024-01-25', 1200.00, 'West'),
('2024-02-05', 2000.00, 'North'),
('2024-02-10', 900.00, 'South'),
('2024-02-15', 1800.00, 'East'),
('2024-02-20', 600.00, 'West'),
('2024-03-01', 2500.00, 'North'),
('2024-03-10', 1100.00, 'South'),
('2024-03-15', 1600.00, 'East'),
('2024-03-20', 1400.00, 'West');
