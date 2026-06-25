WITH monthly AS (
    SELECT
        DATE_TRUNC('month', sale_date)::DATE AS month,
        SUM(amount) AS monthly_sales
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)::DATE
)
SELECT
    month,
    monthly_sales,
    SUM(monthly_sales) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS running_total,
    ROUND(AVG(monthly_sales) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3mo
FROM monthly
ORDER BY month;
