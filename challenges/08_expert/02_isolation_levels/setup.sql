DROP TABLE IF EXISTS accounts CASCADE;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(200) NOT NULL,
    balance NUMERIC(12,2) NOT NULL
);

INSERT INTO accounts (account_name, balance) VALUES
('Checking', 5000.00),
('Savings', 12000.00),
('Investment', 25000.00);
