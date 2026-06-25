DROP TABLE IF EXISTS active_users CASCADE;
DROP TABLE IF EXISTS archived_users CASCADE;

CREATE TABLE active_users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(200) NOT NULL
);

CREATE TABLE archived_users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(200) NOT NULL
);

INSERT INTO active_users (email) VALUES
('alice@example.com'),
('bob@example.com'),
('charlie@example.com'),
('diana@example.com'),
('eve@example.com');

INSERT INTO archived_users (email) VALUES
('charlie@example.com'),
('diana@example.com'),
('frank@example.com'),
('grace@example.com'),
('henry@example.com');
