-- Exercise 1 - Question 1
SELECT name
FROM language;

-- Exercise 1 - Question 2
SELECT
    film.title,
    film.description,
    language.name AS language_name
FROM film
JOIN language
    ON film.language_id = language.language_id;

-- Exercise 1 - Question 3
SELECT
    film.title,
    film.description,
    language.name AS language_name
FROM language
LEFT JOIN film
    ON language.language_id = film.language_id;

-- Exercise 1 - Question 4

CREATE TABLE new_film (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO new_film (name)
VALUES
    ('The Great Adventure'),
    ('Jerusalem Nights'),
    ('Mystery Island');

SELECT *
FROM new_film;

-- Exercise 1 - Question 5

CREATE TABLE customer_review (
    review_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL,
    language_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    score INTEGER CHECK (score BETWEEN 1 AND 10),
    review_text TEXT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (film_id)
        REFERENCES new_film(id)
        ON DELETE CASCADE,

    FOREIGN KEY (language_id)
        REFERENCES language(language_id)
);

-- Exercise 1 - Question 6

INSERT INTO customer_review
    (film_id, language_id, title, score, review_text)
VALUES
    (1, 1, 'Great Movie', 9, 'I really enjoyed this film.'),
    (2, 1, 'Very Enjoyable', 8, 'A fun and interesting movie.');

SELECT *
FROM customer_review;

-- Exercise 1 - Question 7

DELETE FROM new_film
WHERE id = 1;

SELECT *
FROM customer_review;
-- The review linked to the deleted film is automatically deleted
-- because the foreign key uses ON DELETE CASCADE.

-- Exercise 2 - Question 1

UPDATE film
SET language_id = 2
WHERE film_id IN (1, 2, 3);

SELECT
    film.film_id,
    film.title,
    language.name AS language_name
FROM film
JOIN language
    ON film.language_id = language.language_id
WHERE film.film_id IN (1, 2, 3);

-- Exercise 2 - Question 2

SELECT
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_name = 'customer';
-- The customer table has a foreign key on address_id,
-- which references address.address_id.
-- This means that when inserting a new customer,
-- the address_id must already exist in the address table.
-- Otherwise, PostgreSQL will reject the INSERT.

-- Exercise 2 - Question 3

DROP TABLE customer_review;
-- The table can be dropped directly in this case.
-- However, before dropping a table we should check whether
-- other database objects depend on it, because DROP TABLE
-- permanently removes the table and its data.

-- Exercise 2 - Question 4

SELECT COUNT(*) AS outstanding_rentals
FROM rental
WHERE return_date IS NULL;

-- Exercise 2 - Question 5

SELECT
    film.title,
    film.rental_rate
FROM rental
JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
JOIN film
    ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL
ORDER BY film.rental_rate DESC
LIMIT 30;

-- Exercise 2 - Question 6.1

SELECT DISTINCT
    film.title,
    film.description
FROM film
JOIN film_actor
    ON film.film_id = film_actor.film_id
JOIN actor
    ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name ILIKE 'Penelope'
  AND actor.last_name ILIKE 'Monroe'
  AND film.description ILIKE '%sumo%';
-- Result: Park Citizen

-- Exercise 2 - Question 6.2

SELECT
    title,
    description,
    length,
    rating
FROM film
WHERE length < 60
  AND rating = 'R'
  AND description ILIKE '%documentary%';
-- Result: Crossing Divorce

-- Exercise 2 - Question 6.3

SELECT DISTINCT
    film.title,
    payment.amount,
    rental.return_date
FROM customer
JOIN rental
    ON customer.customer_id = rental.customer_id
JOIN payment
    ON rental.rental_id = payment.rental_id
JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
JOIN film
    ON inventory.film_id = film.film_id
WHERE customer.first_name ILIKE 'Matthew'
  AND customer.last_name ILIKE 'Mahan'
  AND payment.amount > 4.00
  AND rental.return_date >= '2005-07-28'
  AND rental.return_date < '2005-08-02';
-- Results: Kissing Dolls and Sugar Wonka

-- Exercise 2 - Question 6.4

SELECT DISTINCT
    film.title,
    film.description,
    film.replacement_cost
FROM customer
JOIN rental
    ON customer.customer_id = rental.customer_id
JOIN inventory
    ON rental.inventory_id = inventory.inventory_id
JOIN film
    ON inventory.film_id = film.film_id
WHERE customer.first_name ILIKE 'Matthew'
  AND customer.last_name ILIKE 'Mahan'
  AND (
      film.title ILIKE '%boat%'
      OR film.description ILIKE '%boat%'
  )
ORDER BY film.replacement_cost DESC;
-- Result: Stone Fire has the highest replacement cost