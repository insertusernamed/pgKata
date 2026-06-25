SELECT *
FROM orders
WHERE status NOT IN ('delivered', 'cancelled')
ORDER BY order_date;
