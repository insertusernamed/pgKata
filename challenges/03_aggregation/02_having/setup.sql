DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);

INSERT INTO employees (first_name, last_name, department, salary) VALUES
('Alice', 'Johnson', 'Engineering', 95000.00),
('Bob', 'Smith', 'Engineering', 72000.00),
('Charlie', 'Brown', 'Engineering', 88000.00),
('Diana', 'Lee', 'Marketing', 55000.00),
('Edward', 'Wilson', 'Marketing', 48000.00),
('Fiona', 'Davis', 'Marketing', 62000.00),
('George', 'Martinez', 'Engineering', 105000.00),
('Hannah', 'Taylor', 'Sales', 51000.00),
('Ian', 'Anderson', 'Sales', 49000.00),
('Julia', 'Thomas', 'Sales', 53000.00),
('Kevin', 'Jackson', 'Engineering', 78000.00),
('Laura', 'White', 'Sales', 47000.00);
