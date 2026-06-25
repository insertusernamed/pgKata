DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL
);

INSERT INTO employees (first_name, last_name, department) VALUES
('Alice', 'Johnson', 'Engineering'),
('Bob', 'Smith', 'Engineering'),
('Charlie', 'Brown', 'Engineering'),
('Diana', 'Lee', 'Marketing'),
('Edward', 'Wilson', 'Marketing'),
('Fiona', 'Davis', 'Sales'),
('George', 'Martinez', 'Sales'),
('Hannah', 'Taylor', 'Sales');
