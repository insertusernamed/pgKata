DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO orders (customer_id, order_date, total) VALUES
(1, '2024-01-15', 150.00),
(2, '2024-01-20', 275.50),
(1, '2024-01-22', 89.99),
(3, '2024-02-05', 450.00),
(2, '2024-02-10', 120.00),
(1, '2024-02-15', 999.99),
(4, '2024-03-01', 65.00),
(3, '2024-03-12', 230.00),
(1, '2024-03-20', 175.50),
(2, '2024-03-25', 320.00),
(4, '2024-04-02', 510.00),
(1, '2024-04-08', 42.99),
(3, '2024-05-14', 780.00),
(2, '2024-05-28', 155.00),
(4, '2024-06-01', 899.99);
