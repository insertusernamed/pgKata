DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1299.99),
('Smartphone', 'Electronics', 899.99),
('Tablet', 'Electronics', 499.99),
('T-shirt', 'Clothing', 29.99),
('Jeans', 'Clothing', 79.99),
('Jacket', 'Clothing', 149.99);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL
);

INSERT INTO orders (order_id) VALUES (1), (2), (3), (4), (5);
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2), (1, 4, 5),
(2, 2, 3), (2, 5, 2),
(3, 3, 1), (3, 6, 3),
(4, 1, 1), (4, 2, 2), (4, 5, 4),
(5, 6, 1), (5, 4, 10);
