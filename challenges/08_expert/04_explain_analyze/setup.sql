DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP INDEX IF EXISTS idx_orders_customer;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    total NUMERIC(10,2) NOT NULL
);

INSERT INTO customers (name)
SELECT 'Customer ' || generate_series FROM generate_series(1, 100);

INSERT INTO orders (customer_id, total)
SELECT (random() * 99 + 1)::int, (random() * 1000)::numeric(10,2)
FROM generate_series(1, 1000);
