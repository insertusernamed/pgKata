SELECT
    DATE_TRUNC('month', sale_date)::DATE AS month,
    SUM(amount) AS total,
    SUM(amount) FILTER (WHERE region = 'North') AS north,
    SUM(amount) FILTER (WHERE region = 'South') AS south,
    SUM(amount) FILTER (WHERE region = 'East') AS east,
    SUM(amount) FILTER (WHERE region = 'West') AS west
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)::DATE
ORDER BY month;
