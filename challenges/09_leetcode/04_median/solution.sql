SELECT
    department,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary)::numeric, 2) AS median_salary
FROM employees
GROUP BY department
ORDER BY department;
