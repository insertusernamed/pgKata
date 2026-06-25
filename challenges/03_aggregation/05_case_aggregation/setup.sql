DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(200) NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_name VARCHAR(200) NOT NULL,
    course_id INT REFERENCES courses(course_id),
    score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100)
);

INSERT INTO courses (course_name) VALUES
('Database Design'),
('Web Development'),
('Data Structures');

INSERT INTO enrollments (student_name, course_id, score) VALUES
('Alice', 1, 95), ('Bob', 1, 87), ('Charlie', 1, 72), ('Diana', 1, 55),
('Edward', 2, 91), ('Fiona', 2, 83), ('George', 2, 78), ('Hannah', 2, 64),
('Ian', 2, 59), ('Julia', 3, 98), ('Kevin', 3, 88), ('Laura', 3, 92),
('Mike', 3, 73), ('Nancy', 3, 81);
