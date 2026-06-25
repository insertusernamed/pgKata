DROP TABLE IF EXISTS logs CASCADE;

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    num INTEGER NOT NULL
);

INSERT INTO logs (num) VALUES
(1), (1), (1), (2), (2), (3), (3), (3), (3), (4), (5), (5), (6);
