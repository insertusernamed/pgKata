DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP FUNCTION IF EXISTS total_orders_for_customer;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (name) VALUES ('Alice Johnson'), ('Bob Smith');
INSERT INTO orders (customer_id, total) VALUES (1, 150.00), (1, 89.99), (2, 275.50), (1, 450.00);
