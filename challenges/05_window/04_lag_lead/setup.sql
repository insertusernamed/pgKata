DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    hire_date DATE NOT NULL
);

INSERT INTO employees (name, salary, hire_date) VALUES
('Alice', 95000.00, '2019-03-15'),
('Bob', 72000.00, '2020-06-01'),
('Charlie', 88000.00, '2021-01-10'),
('Diana', 105000.00, '2021-09-22'),
('Edward', 65000.00, '2022-04-05'),
('Fiona', 78000.00, '2023-02-14');
