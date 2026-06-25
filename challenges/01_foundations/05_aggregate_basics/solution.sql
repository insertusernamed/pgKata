SELECT
    DATE_TRUNC('month', order_date)::DATE AS month,
    SUM(total) AS total_revenue,
    ROUND(AVG(total), 2) AS avg_order,
    COUNT(*) AS num_orders,
    MAX(total) AS highest_order
FROM orders
GROUP BY DATE_TRUNC('month', order_date)::DATE
ORDER BY month;
