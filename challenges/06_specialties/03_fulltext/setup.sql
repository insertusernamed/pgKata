DROP TABLE IF EXISTS blog_posts CASCADE;

CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    body TEXT NOT NULL,
    published_date DATE NOT NULL
);

INSERT INTO blog_posts (title, body, published_date) VALUES
('Getting Started with PostgreSQL', 'PostgreSQL is a powerful open-source database. Learn how to install and configure it.', '2024-01-15'),
('Advanced Query Tuning', 'Learn about query performance optimization. Use EXPLAIN ANALYZE to find slow queries and tune them with proper indexes.', '2024-02-10'),
('Database Indexing Strategies', 'Choosing the right index type for your data is crucial for database performance. B-tree, GiST, and GIN indexes each have their place.', '2024-03-05'),
('Migration from MySQL to PostgreSQL', 'Migrating your database requires careful planning. Consider data types, stored procedures, and performance characteristics.', '2024-04-20'),
('PostgreSQL Performance Monitoring', 'Monitor your database performance with pg_stat_statements, pg_stat_activity, and custom dashboards.', '2024-05-12'),
('Introduction to NoSQL', 'Explore document databases and key-value stores as alternatives to traditional relational databases.', '2024-06-01');
