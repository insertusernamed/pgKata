DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    region VARCHAR(100) NOT NULL
);

INSERT INTO sales (sale_date, amount, region) VALUES
('2024-01-15', 1000.00, 'North'),
('2024-02-10', 1500.00, 'South'),
('2024-03-05', 800.00, 'North'),
('2024-04-20', 2000.00, 'East'),
('2024-05-12', 1200.00, 'West'),
('2024-06-01', 1800.00, 'North'),
('2024-07-15', 900.00, 'South'),
('2024-08-22', 2500.00, 'East'),
('2024-09-10', 1600.00, 'West'),
('2024-10-05', 1100.00, 'North'),
('2024-11-18', 1900.00, 'South'),
('2024-12-25', 3000.00, 'East'),
('2023-01-20', 750.00, 'North'),
('2023-06-15', 1200.00, 'West'),
('2023-11-30', 2100.00, 'East');
