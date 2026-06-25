DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice@example.com'),
('Bob', 'Smith', 'bob@example.com'),
('Charlie', 'Brown', 'charlie@example.com');

INSERT INTO orders (customer_id, order_date, total) VALUES
(1, '2024-01-15', 150.00),
(2, '2024-01-20', 275.50),
(1, '2024-02-01', 89.99),
(3, '2024-02-15', 450.00),
(2, '2024-03-01', 120.00),
(NULL, '2024-03-10', 99.99);
