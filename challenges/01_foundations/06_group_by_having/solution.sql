SELECT
    department,
    COUNT(*) AS headcount,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING COUNT(*) >= 2 AND SUM(salary) > 150000;
