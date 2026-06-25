DROP TABLE IF EXISTS products CASCADE;
DROP PROCEDURE IF EXISTS transfer_product_stock;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0)
);

INSERT INTO products (product_name, quantity) VALUES
('Widget A', 100),
('Widget B', 50),
('Widget C', 10);
