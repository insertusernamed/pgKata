DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);

INSERT INTO employees (name, salary) VALUES
('Alice', 120000.00),
('Bob', 110000.00),
('Charlie', 105000.00),
('Diana', 95000.00),
('Edward', 88000.00),
('Fiona', 82000.00),
('George', 75000.00),
('Hannah', 72000.00),
('Ian', 65000.00),
('Julia', 58000.00),
('Kevin', 52000.00),
('Laura', 48000.00);
