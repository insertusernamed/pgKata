DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    metadata JSONB
);

INSERT INTO products (product_name, price, metadata) VALUES
('Red T-shirt', 29.99, '{"color": "red", "size": "M", "material": "cotton", "in_stock": true}'),
('Blue Jeans', 79.99, '{"color": "blue", "size": "32", "material": "denim", "in_stock": true}'),
('Green Jacket', 149.99, '{"color": "green", "size": "L", "material": "polyester", "in_stock": false}'),
('Wireless Mouse', 49.99, '{"color": "black", "type": "bluetooth", "dpi": 1600, "in_stock": true}'),
('Desk Lamp', 39.99, '{"color": "white", "brightness": "adjustable", "in_stock": true}'),
('Notebook Set', 14.99, '{"pages": 200, "type": "spiral", "in_stock": true}'),
('Running Shoes', 129.99, '{"color": "black", "size": "10", "material": "mesh", "in_stock": true, "brand": "Nike"}');
