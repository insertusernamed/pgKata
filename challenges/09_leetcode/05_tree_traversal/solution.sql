SELECT
    id,
    CASE
        WHEN parent_id IS NULL THEN 'Root'
        WHEN EXISTS (SELECT 1 FROM nodes child WHERE child.parent_id = n.id) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM nodes n
ORDER BY id;
