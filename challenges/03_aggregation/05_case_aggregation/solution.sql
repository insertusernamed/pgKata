SELECT
    c.course_name AS course,
    COUNT(*) FILTER (WHERE e.score >= 90) AS a_count,
    COUNT(*) FILTER (WHERE e.score >= 80 AND e.score < 90) AS b_count,
    COUNT(*) FILTER (WHERE e.score >= 70 AND e.score < 80) AS c_count,
    COUNT(*) FILTER (WHERE e.score >= 60 AND e.score < 70) AS d_count,
    COUNT(*) FILTER (WHERE e.score < 60) AS f_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY c.course_name;
