DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    manager_id INT REFERENCES employees(employee_id)
);

INSERT INTO employees (name, manager_id) VALUES
('CEO', NULL),
('VP Engineering', 1),
('VP Marketing', 1),
('VP Sales', 1),
('Engineering Director', 2),
('Senior Developer', 5),
('Junior Developer', 6),
('Marketing Manager', 3),
('Marketing Specialist', 8),
('Sales Manager', 4),
('Sales Rep', 10);
