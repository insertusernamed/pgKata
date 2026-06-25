DROP TABLE IF EXISTS stadium CASCADE;

CREATE TABLE stadium (
    id SERIAL PRIMARY KEY,
    visit_date DATE NOT NULL,
    people INTEGER NOT NULL
);

INSERT INTO stadium (visit_date, people) VALUES
('2024-01-01', 50),
('2024-01-02', 150),
('2024-01-03', 200),
('2024-01-04', 120),
('2024-01-05', 80),
('2024-01-06', 90),
('2024-01-07', 300),
('2024-01-08', 250),
('2024-01-09', 180),
('2024-01-10', 70);
