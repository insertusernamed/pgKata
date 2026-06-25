DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS salespeople CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

CREATE TABLE salespeople (
    salesperson_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    salesperson_id INT REFERENCES salespeople(salesperson_id),
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL
);

INSERT INTO customers (first_name, last_name) VALUES
('Alice', 'Johnson'), ('Bob', 'Smith');

INSERT INTO salespeople (first_name, last_name) VALUES
('Carol', 'Williams'), ('David', 'Brown');

INSERT INTO products (product_name, price) VALUES
('Widget', 10.00), ('Gadget', 25.00), ('Doohickey', 50.00);

INSERT INTO orders (customer_id, salesperson_id, order_date) VALUES
(1, 1, '2024-01-15'), (2, 2, '2024-01-20'), (1, 2, '2024-02-01');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 5), (1, 2, 2), (2, 3, 1), (3, 1, 3), (3, 2, 4);
