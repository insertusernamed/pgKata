DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    department VARCHAR(100) NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);

INSERT INTO employees (name, department, salary) VALUES
('Alice', 'Engineering', 95000.00),
('Bob', 'Engineering', 72000.00),
('Charlie', 'Engineering', 105000.00),
('Diana', 'Engineering', 88000.00),
('Edward', 'Marketing', 72000.00),
('Fiona', 'Marketing', 65000.00),
('George', 'Marketing', 58000.00);
