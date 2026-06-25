DROP TABLE IF EXISTS projects CASCADE;

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    budget NUMERIC(12,2)
);

INSERT INTO projects (project_name, start_date, end_date, budget) VALUES
('Website Redesign', '2024-01-15', '2024-06-30', 50000.00),
('Mobile App v2', '2024-03-01', '2024-09-15', 120000.00),
('Database Migration', '2024-05-01', '2024-10-31', 80000.00),
('AI Chatbot', '2024-07-01', NULL, 200000.00),
('Security Audit', '2024-02-01', '2024-04-15', 35000.00),
('Cloud Infrastructure', '2024-06-01', '2024-12-31', 150000.00),
('Data Pipeline v3', '2024-04-01', '2024-08-01', 95000.00),
('Legacy System Upgrade', '2023-11-01', '2024-03-31', 180000.00),
('Quick Project', '2025-01-01', '2025-05-15', 25000.00),
('Overdue Task', '2024-12-01', '2025-01-01', 5000.00);
