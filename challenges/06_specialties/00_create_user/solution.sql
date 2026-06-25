DO $$ BEGIN
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'readonly_user') THEN
        DROP OWNED BY readonly_user CASCADE;
        DROP USER readonly_user;
    END IF;
END $$;
CREATE USER readonly_user WITH PASSWORD 'readonly_pass';
GRANT SELECT ON customers TO readonly_user;
