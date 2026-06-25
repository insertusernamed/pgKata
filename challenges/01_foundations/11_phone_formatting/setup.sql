DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (firstname, lastname, username, password, email, created_on)
VALUES 
('Alison', 'Riesher', 'alisoninthesun', 'l09+#k$nalA!', 'sunnysideup@myemail.com', CURRENT_TIMESTAMP),
('Edgar', 'Tobin', 'edgar163', 'BSI@uj0_qwT%', 'edgar163@email.com', CURRENT_TIMESTAMP),
('Frank', 'Lawson', 'frank_lawson', '32oktn*_WKn89', 'frank@lawsonhardware.com', CURRENT_TIMESTAMP),
('Kiara', 'Mendez', 'kiaradiamond', '9s9dSn$LStt', 'kdiamond@myemail.com', CURRENT_TIMESTAMP),
('Taylor', 'Hiu', 'taytay89', 'U09$hjqlaBM', 'taytay89@myemail.com', CURRENT_TIMESTAMP),
('Jordan', 'Lee', 'jlee42', 'P@ss123!', 'jlee@email.com', CURRENT_TIMESTAMP),
('Sam', 'Wilson', 'samwilson', 'SecurePwd1', 'sam@email.com', CURRENT_TIMESTAMP),
('Alex', 'Chen', 'achen_dev', 'DevPass!23', 'achen@email.com', CURRENT_TIMESTAMP);
