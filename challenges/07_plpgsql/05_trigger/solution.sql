CREATE OR REPLACE FUNCTION audit_salary_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO salary_audit (employee_id, old_salary, new_salary)
    VALUES (OLD.employee_id, OLD.salary, NEW.salary);
    RETURN NEW;
END;
$$;

CREATE TRIGGER salary_update_audit
    AFTER UPDATE OF salary ON employees
    FOR EACH ROW
    EXECUTE FUNCTION audit_salary_change();
