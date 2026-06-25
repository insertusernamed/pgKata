DROP TABLE IF EXISTS jobs CASCADE;

CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    job_type VARCHAR(100) NOT NULL,
    payload TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO jobs (job_type, payload, status, created_at) VALUES
('email', 'Welcome email', 'pending', '2024-01-01 10:00:00'),
('report', 'Generate monthly report', 'pending', '2024-01-01 10:05:00'),
('backup', 'Database backup', 'in_progress', '2024-01-01 09:00:00'),
('cleanup', 'Temp file cleanup', 'pending', '2024-01-01 10:10:00'),
('notification', 'Push notification', 'completed', '2024-01-01 08:00:00');
