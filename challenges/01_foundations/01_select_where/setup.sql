DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL
);

INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES
('Alice', 'Johnson', 'Engineering', 95000.00, '2020-03-15'),
('Bob', 'Smith', 'Engineering', 72000.00, '2021-06-01'),
('Charlie', 'Brown', 'Engineering', 58000.00, '2022-01-10'),
('Diana', 'Lee', 'Marketing', 82000.00, '2019-11-20'),
('Edward', 'Wilson', 'Marketing', 55000.00, '2023-02-14'),
('Fiona', 'Davis', 'Engineering', 105000.00, '2018-07-08'),
('George', 'Martinez', 'Sales', 63000.00, '2021-09-05'),
('Hannah', 'Taylor', 'Sales', 48000.00, '2022-08-22');
