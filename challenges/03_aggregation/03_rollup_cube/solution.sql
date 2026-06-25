SELECT
    EXTRACT(YEAR FROM sale_date)::int AS year,
    SUM(amount) AS total_sales
FROM sales
GROUP BY ROLLUP(EXTRACT(YEAR FROM sale_date)::int)
HAVING GROUPING(EXTRACT(YEAR FROM sale_date)::int) = 0
ORDER BY year;
