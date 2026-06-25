DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL
);

INSERT INTO products (product_name, category, price, stock) VALUES
('Wireless Mouse', 'Electronics', 29.99, 150),
('Mechanical Keyboard', 'Electronics', 149.99, 75),
('USB-C Hub', 'Electronics', 45.99, 200),
('Standing Desk', 'Furniture', 599.99, 30),
('Ergonomic Chair', 'Furniture', 899.99, 15),
('Monitor Arm', 'Furniture', 129.99, 60),
('Noise Canceling Headphones', 'Electronics', 349.99, 40),
('Webcam 4K', 'Electronics', 199.99, 85),
('Desk Lamp', 'Furniture', 79.99, 120),
('Laptop Stand', 'Furniture', 49.99, 95);
