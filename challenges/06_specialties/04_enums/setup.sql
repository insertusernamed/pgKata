DROP TABLE IF EXISTS orders CASCADE;
DROP TYPE IF EXISTS order_status CASCADE;

CREATE TYPE order_status AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(200) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    status order_status NOT NULL DEFAULT 'pending',
    order_date DATE NOT NULL
);

INSERT INTO orders (customer_name, total, status, order_date) VALUES
('Alice Johnson', 150.00, 'delivered', '2024-01-15'),
('Bob Smith', 275.50, 'shipped', '2024-01-20'),
('Charlie Brown', 89.99, 'processing', '2024-02-01'),
('Diana Lee', 450.00, 'pending', '2024-02-15'),
('Edward Wilson', 120.00, 'delivered', '2024-03-01'),
('Fiona Davis', 210.00, 'cancelled', '2024-03-10'),
('George Martinez', 330.00, 'processing', '2024-03-15'),
('Hannah Taylor', 85.00, 'shipped', '2024-03-20');
