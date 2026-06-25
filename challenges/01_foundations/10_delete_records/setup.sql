DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

INSERT INTO customers (firstname, lastname, email) VALUES
('Alison', 'Riesher', 'alison@email.com'),
('Bob', 'Smith', 'bob@email.com'),
('Alice', 'Smith', 'alice@email.com'),
('Charlie', 'Brown', 'charlie@email.com'),
('Diana', 'Lee', 'diana@email.com');
