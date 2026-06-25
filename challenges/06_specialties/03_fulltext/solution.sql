SELECT title
FROM blog_posts
WHERE to_tsvector('english', title || ' ' || body) @@ plainto_tsquery('english', 'database performance')
ORDER BY ts_rank(
    to_tsvector('english', title || ' ' || body),
    plainto_tsquery('english', 'database performance')
) DESC;
