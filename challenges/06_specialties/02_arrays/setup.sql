DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    skills VARCHAR(100)[] NOT NULL,
    years_experience INTEGER NOT NULL
);

INSERT INTO employees (name, skills, years_experience) VALUES
('Alice Johnson', ARRAY['Python', 'SQL', 'Django', 'PostgreSQL'], 5),
('Bob Smith', ARRAY['Java', 'Spring', 'SQL'], 3),
('Charlie Brown', ARRAY['Python', 'JavaScript', 'React', 'Node.js'], 4),
('Diana Lee', ARRAY['Python', 'SQL', 'PostgreSQL', 'AWS', 'Docker'], 7),
('Edward Wilson', ARRAY['C#', '.NET', 'SQL Server'], 6),
('Fiona Davis', ARRAY['Python', 'SQL', 'Machine Learning', 'TensorFlow'], 4),
('George Martinez', ARRAY['Go', 'Kubernetes', 'Docker', 'PostgreSQL'], 5),
('Hannah Taylor', ARRAY['Ruby', 'Rails', 'SQL', 'PostgreSQL'], 3);
