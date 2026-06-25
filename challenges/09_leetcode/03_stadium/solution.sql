WITH qualifying AS (
    SELECT id, visit_date, people,
        id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM stadium
    WHERE people >= 100
)
SELECT visit_date, people
FROM qualifying
WHERE grp IN (
    SELECT grp FROM qualifying GROUP BY grp HAVING COUNT(*) >= 3
)
ORDER BY visit_date;
