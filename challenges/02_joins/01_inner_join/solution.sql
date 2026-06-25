SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    o.total
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
