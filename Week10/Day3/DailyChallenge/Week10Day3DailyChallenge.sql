-- Daily Challenge: SQL Puzzle

DROP TABLE IF EXISTS SecondTab;
DROP TABLE IF EXISTS FirstTab;

CREATE TABLE FirstTab (
    id INTEGER,
    name VARCHAR(10)
);

INSERT INTO FirstTab VALUES
(5, 'Pawan'),
(6, 'Sharlee'),
(7, 'Krish'),
(NULL, 'Avtaar');

SELECT * FROM FirstTab;

CREATE TABLE SecondTab (
    id INTEGER
);

INSERT INTO SecondTab VALUES
(5),
(NULL);

SELECT * FROM SecondTab;


-- Q1
-- Prediction: 0

SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (
    SELECT id
    FROM SecondTab
    WHERE id IS NULL
);


-- Q2
-- Prediction: 2
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (
    SELECT id
    FROM SecondTab
    WHERE id = 5
);


-- Q3
-- Prediction: 0
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (
    SELECT id
    FROM SecondTab
);


-- Q4
-- Prediction: 2
SELECT COUNT(*)
FROM FirstTab AS ft
WHERE ft.id NOT IN (
    SELECT id
    FROM SecondTab
    WHERE id IS NOT NULL
);