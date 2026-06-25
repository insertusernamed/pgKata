DROP TABLE IF EXISTS customers CASCADE;
DO $$ BEGIN
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'readonly_user') THEN
        EXECUTE 'REVOKE ALL PRIVILEGES ON DATABASE ' || current_database() || ' FROM readonly_user';
        DROP OWNED BY readonly_user CASCADE;
        DROP USER readonly_user;
    END IF;
END $$;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

INSERT INTO customers (firstname, lastname, email) VALUES
('Alison', 'Riesher', 'alison@email.com'),
('Bob', 'Smith', 'bob@email.com');
