SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer,
    s.first_name || ' ' || s.last_name AS salesperson,
    p.product_name AS product,
    oi.quantity AS qty
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN salespeople s ON o.salesperson_id = s.salesperson_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_name;
