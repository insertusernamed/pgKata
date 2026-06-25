CREATE OR REPLACE FUNCTION get_department_summary()
RETURNS TABLE(department VARCHAR, employee_count BIGINT, total_salary NUMERIC, avg_salary NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.department::VARCHAR, COUNT(*)::BIGINT, SUM(e.salary), ROUND(AVG(e.salary), 2)
    FROM employees e
    GROUP BY e.department;
END;
$$;
