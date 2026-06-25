SELECT email AS in_both_tables
FROM active_users
INTERSECT
SELECT email
FROM archived_users;
