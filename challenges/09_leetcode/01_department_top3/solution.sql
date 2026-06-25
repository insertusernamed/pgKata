SELECT d.name AS department, e.name AS employee, e.salary
FROM (
    SELECT
        name,
        salary,
        department_id,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM employee
) e
JOIN department d ON e.department_id = d.id
WHERE e.rnk <= 3
ORDER BY d.name, e.salary DESC;
