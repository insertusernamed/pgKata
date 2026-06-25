DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

INSERT INTO customers (first_name, last_name) VALUES
('Alice', 'Johnson'), ('Bob', 'Smith'), ('Charlie', 'Brown');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO orders (customer_id, order_date, total) VALUES
(1, '2024-03-01', 150.00),
(1, '2024-01-15', 200.00),
(1, '2024-06-10', 89.99),
(2, '2024-02-20', 275.50),
(2, '2024-05-05', 120.00),
(3, '2024-04-01', 450.00),
(3, '2024-07-15', 300.00),
(3, '2024-09-01', 175.00),
(3, '2024-01-10', 500.00);
