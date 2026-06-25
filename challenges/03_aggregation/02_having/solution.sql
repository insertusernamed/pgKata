SELECT
    department,
    ROUND(AVG(salary), 2) AS avg_salary,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000 AND COUNT(*) >= 3;
