SELECT
    e1.first_name || ' ' || e1.last_name AS employee_1,
    e2.first_name || ' ' || e2.last_name AS employee_2,
    e1.department
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE e1.employee_id < e2.employee_id;
