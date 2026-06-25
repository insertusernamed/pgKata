DROP TABLE IF EXISTS products CASCADE;
DROP FUNCTION IF EXISTS get_products_by_price_range;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    category VARCHAR(100) NOT NULL
);

INSERT INTO products (name, price, category) VALUES
('Laptop', 1299.99, 'Electronics'),
('Smartphone', 899.99, 'Electronics'),
('Tablet', 499.99, 'Electronics'),
('T-shirt', 29.99, 'Clothing'),
('Jeans', 79.99, 'Clothing'),
('Jacket', 149.99, 'Clothing'),
('Cookbook', 39.99, 'Books'),
('Novel', 14.99, 'Books');
