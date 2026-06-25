DROP TABLE IF EXISTS salary_audit CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP FUNCTION IF EXISTS audit_salary_change CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    salary NUMERIC(10,2) NOT NULL
);

CREATE TABLE salary_audit (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    old_salary NUMERIC(10,2),
    new_salary NUMERIC(10,2),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employees (name, salary) VALUES
('Alice Johnson', 95000.00),
('Bob Smith', 72000.00),
('Charlie Brown', 88000.00);
