WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
ranked_products AS (
    SELECT
        category,
        product_name,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rn
    FROM product_revenue
)
SELECT category, product_name, total_revenue
FROM ranked_products
WHERE rn <= 2
ORDER BY category, total_revenue DESC;
