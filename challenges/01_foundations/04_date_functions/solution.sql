SELECT
    project_name,
    (DATE '2025-04-01' - end_date) AS days_overdue
FROM projects
WHERE end_date IS NOT NULL
  AND end_date < DATE '2025-04-01'
ORDER BY days_overdue DESC;
