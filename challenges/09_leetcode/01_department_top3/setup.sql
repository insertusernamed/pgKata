DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS department CASCADE;

CREATE TABLE department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    department_id INT REFERENCES department(id)
);

INSERT INTO department (name) VALUES
('Engineering'), ('Marketing'), ('Sales');

INSERT INTO employee (name, salary, department_id) VALUES
('Alice', 95000.00, 1),
('Bob', 88000.00, 1),
('Charlie', 88000.00, 1),
('Diana', 72000.00, 1),
('Edward', 65000.00, 2),
('Fiona', 62000.00, 2),
('George', 58000.00, 2),
('Hannah', 55000.00, 2),
('Ian', 52000.00, 3),
('Julia', 51000.00, 3);
