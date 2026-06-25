SELECT
    name,
    array_length(skills, 1) AS skill_count,
    years_experience
FROM employees
WHERE 'Python' = ANY(skills)
ORDER BY years_experience DESC;
