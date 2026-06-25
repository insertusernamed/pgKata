DROP TABLE IF EXISTS documents CASCADE;
DROP USER IF EXISTS test_user;

CREATE TABLE documents (
    doc_id SERIAL PRIMARY KEY,
    owner VARCHAR(100) NOT NULL,
    title VARCHAR(300) NOT NULL,
    content TEXT
);

INSERT INTO documents (owner, title, content) VALUES
('alice', 'Project Plan', 'Q1 planning document'),
('alice', 'Budget Report', 'Annual budget breakdown'),
('bob', 'Meeting Notes', 'Sprint retrospective notes'),
('bob', 'Code Review', 'Review guidelines for team'),
('charlie', 'Architecture Doc', 'System architecture overview');

CREATE USER test_user WITH PASSWORD 'test';
GRANT SELECT ON documents TO test_user;
GRANT ALL ON documents TO test_user;
