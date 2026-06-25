CREATE INDEX idx_lower_email ON customers(LOWER(email));
CREATE INDEX idx_pending_orders ON orders(status) WHERE status = 'pending';

SELECT c.name, c.email, o.total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE LOWER(c.email) = 'alice@example.com'
  AND o.status = 'pending';
