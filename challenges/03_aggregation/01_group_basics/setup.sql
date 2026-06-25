DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL
);

INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 1299.99, 25),
('Smartphone', 'Electronics', 899.99, 50),
('Tablet', 'Electronics', 499.99, 30),
('T-shirt', 'Clothing', 29.99, 200),
('Jeans', 'Clothing', 79.99, 100),
('Jacket', 'Clothing', 149.99, 60),
('Cookbook', 'Books', 39.99, 150),
('Novel', 'Books', 14.99, 300),
('Textbook', 'Books', 89.99, 45),
('Notebook', 'Stationery', 9.99, 500),
('Pen Set', 'Stationery', 19.99, 350),
('Desk Lamp', 'Stationery', 49.99, 80);
