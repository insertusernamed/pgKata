SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    o.total
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
