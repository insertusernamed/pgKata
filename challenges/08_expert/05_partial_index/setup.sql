DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(300) NOT NULL
);

INSERT INTO customers (name, email) VALUES
('Alice', 'Alice@Example.com'),
('Bob', 'BOB@EXAMPLE.COM'),
('Charlie', 'Charlie@Example.org');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO orders (customer_id, status, total) VALUES
(1, 'pending', 100.00),
(1, 'shipped', 200.00),
(2, 'pending', 150.00),
(2, 'delivered', 300.00),
(3, 'pending', 75.00),
(3, 'cancelled', 50.00);
