SELECT
    first_name || ' ' || last_name AS name,
    department,
    salary,
    ROUND((
        SELECT AVG(salary)
        FROM employees e2
        WHERE e2.department = e1.department
    ), 2) AS dept_avg_salary,
    ROUND(salary - (
        SELECT AVG(salary)
        FROM employees e2
        WHERE e2.department = e1.department
    ), 2) AS salary_diff
FROM employees e1
ORDER BY department, salary DESC;
