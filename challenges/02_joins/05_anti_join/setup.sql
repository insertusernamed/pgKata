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
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice@example.com'),
('Bob', 'Smith', 'bob@example.com'),
('Charlie', 'Brown', 'charlie@example.com'),
('Diana', 'Lee', 'diana@example.com'),
('Edward', 'Wilson', 'edward@example.com'),
('Fiona', 'Davis', 'fiona@example.com');

INSERT INTO orders (customer_id, total) VALUES
(1, 150.00), (2, 275.50), (1, 89.99), (3, 450.00), (2, 120.00);
