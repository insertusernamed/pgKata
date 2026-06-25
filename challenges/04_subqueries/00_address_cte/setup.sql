DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL
);

INSERT INTO customers (firstname, lastname) VALUES
('Alison', 'Riesher'), ('Edgar', 'Tobin'), ('Frank', 'Lawson'),
('Kiara', 'Mendez'), ('Taylor', 'Hiu');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    purchase_total NUMERIC(10,2) NOT NULL,
    customer_id INT REFERENCES customers(customer_id)
);

INSERT INTO orders (purchase_total, customer_id) VALUES
(77.96, 1), (500.13, 1), (24.14, 2), (123.45, 2), (90.90, 1),
(45.01, 3), (72.83, 2), (11.21, 3), (86.23, 4), (224.35, 5);
