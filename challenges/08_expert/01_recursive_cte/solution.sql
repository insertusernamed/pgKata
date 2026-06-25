WITH RECURSIVE org_tree AS (
    SELECT
        employee_id,
        name,
        0 AS level,
        name::TEXT AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.name,
        ot.level + 1,
        ot.path || ' -> ' || e.name
    FROM employees e
    JOIN org_tree ot ON e.manager_id = ot.employee_id
)
SELECT * FROM org_tree
ORDER BY path;
