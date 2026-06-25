SELECT department, employee, salary, rank
FROM (
    SELECT
        department,
        first_name || ' ' || last_name AS employee,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
    FROM employees
) ranked
WHERE rank <= 3
ORDER BY department, rank;
