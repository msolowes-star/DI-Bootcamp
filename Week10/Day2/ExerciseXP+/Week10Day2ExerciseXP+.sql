-- Daily Challenge: Students Table

-- Create students table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    birth_date DATE
);

-- Insert the 6 students
INSERT INTO students (first_name, last_name, birth_date)
VALUES
    ('Marc', 'Benichou', '1998-11-02'),
    ('Yoan', 'Cohen', '2010-12-03'),
    ('Lea', 'Benichou', '1987-07-27'),
    ('Amelia', 'Dux', '1996-04-07'),
    ('David', 'Grez', '2003-06-14'),
    ('Omer', 'Simpson', '1980-10-03');

-- Insert your own information
INSERT INTO students (first_name, last_name, birth_date)
VALUES
    ('Marc', 'Soloweszyk', '1983-04-26');


-- 1. Fetch all data
SELECT *
FROM students;


-- 2. Fetch all first names and last names
SELECT first_name, last_name
FROM students;


-- 3.1 Student with id = 2
SELECT first_name, last_name
FROM students
WHERE id = 2;


-- 3.2 Last name Benichou AND first name Marc
SELECT first_name, last_name
FROM students
WHERE last_name = 'Benichou'
AND first_name = 'Marc';


-- 3.3 Last name Benichou OR first name Marc
SELECT first_name, last_name
FROM students
WHERE last_name = 'Benichou'
OR first_name = 'Marc';


-- 3.4 First names containing the letter a
SELECT first_name, last_name
FROM students
WHERE first_name ILIKE '%a%';


-- 3.5 First names starting with a
SELECT first_name, last_name
FROM students
WHERE first_name ILIKE 'a%';


-- 3.6 First names ending with a
SELECT first_name, last_name
FROM students
WHERE first_name ILIKE '%a';


-- 3.7 Second-to-last letter is a
SELECT first_name, last_name
FROM students
WHERE first_name ILIKE '%a_';


-- 3.8 Students whose ids are 1 and 3
SELECT first_name, last_name
FROM students
WHERE id IN (1, 3);


-- 4. Birth dates equal to or after January 1, 2000
SELECT *
FROM students
WHERE birth_date >= '2000-01-01';