SELECT
    c.first_name || ' ' || c.last_name AS customer,
    o.order_date,
    o.total,
    ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS order_num
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, order_num;
