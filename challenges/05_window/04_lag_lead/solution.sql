SELECT
    name,
    salary,
    LAG(salary) OVER (ORDER BY hire_date) AS prev_salary,
    LEAD(salary) OVER (ORDER BY hire_date) AS next_salary,
    salary - LAG(salary) OVER (ORDER BY hire_date) AS diff_from_prev
FROM employees
ORDER BY hire_date;
