DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (first_name, last_name) VALUES
('Alice', 'Johnson'),
('Bob', 'Smith'),
('Charlie', 'Brown'),
('Diana', 'Lee');

INSERT INTO orders (customer_id, total) VALUES
(1, 150.00),
(1, 89.99),
(2, 275.50),
(3, 450.00);
