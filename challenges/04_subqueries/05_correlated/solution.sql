SELECT
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    ROUND((
        SELECT AVG(salary)
        FROM employees e2
        WHERE e2.department = e1.department
    ), 2) AS dept_avg
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department = e1.department
)
ORDER BY salary DESC;
