CREATE INDEX idx_orders_customer ON orders(customer_id);

EXPLAIN
SELECT c.name AS customer_name, o.total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id = 42;
