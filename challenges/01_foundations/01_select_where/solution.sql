SELECT first_name, last_name, salary
FROM employees
WHERE department = 'Engineering'
  AND salary > 60000;
