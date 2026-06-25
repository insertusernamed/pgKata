DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL,
    bio TEXT
);

INSERT INTO users (username, email, bio) VALUES
('alice_wonder', 'Alice.Wonder@Example.com', 'Full-stack developer and coffee enthusiast'),
('bob_builder', 'BOB.BUILDER@EXAMPLE.COM', 'DevOps engineer who loves automation'),
('charlie_chaplin', 'Charlie.Chaplin@Example.com', NULL),
('diana_prince', 'Diana.Prince@EXAMPLE.ORG', 'Database administrator for over 10 years'),
('eve_adams', 'Eve.Adams@Example.net', 'Frontend developer passionate about accessibility');
