DROP TABLE IF EXISTS nodes CASCADE;

CREATE TABLE nodes (
    id SERIAL PRIMARY KEY,
    parent_id INT REFERENCES nodes(id)
);

INSERT INTO nodes (id, parent_id) VALUES
(1, NULL),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 3),
(7, 4),
(8, 7);
