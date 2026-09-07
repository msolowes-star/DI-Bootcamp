-- Daily Challenge: Actors

-- 1. Count how many actors are in the table
SELECT COUNT(*)
FROM actors;

-- 2. Try to add a new actor with blank fields

INSERT INTO actors (first_name, last_name)
VALUES ('Brad', 'Pitt');

-- Outcome:
-- The INSERT fails because birthdate and number_oscars
-- have NOT NULL constraints.
-- PostgreSQL does not allow NULL values in these columns.