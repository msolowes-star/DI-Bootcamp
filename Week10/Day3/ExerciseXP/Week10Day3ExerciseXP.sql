-- Exercise 2: dvdrental

-- 1. Select all columns from the customer table
SELECT *
FROM customer;

-- 2. Display first and last name as full_name
SELECT first_name || ' ' || last_name AS full_name
FROM customer;

-- 3. Get all unique account creation dates
SELECT DISTINCT create_date
FROM customer;

-- 4. All customer details ordered by first name descending
SELECT *
FROM customer
ORDER BY first_name DESC;

-- 5. Film details ordered by rental rate ascending
SELECT film_id, title, description, release_year, rental_rate
FROM film
ORDER BY rental_rate ASC;

-- 6. Address and phone number for customers in the Texas district
SELECT address, phone
FROM address
WHERE district = 'Texas';

-- 7. Get all movie details where film ID is 15 or 150
SELECT *
FROM film
WHERE film_id IN (15, 150);

-- 8. Check if my favorite movie exists
SELECT film_id, title, description, length, rental_rate
FROM film
WHERE title = 'The Shawshank Redemption';

-- 9. Search for movies starting with the first two letters
-- of my favorite movie
SELECT film_id, title, description, length, rental_rate
FROM film
WHERE title ILIKE 'Th%';

-- 10. Find the 10 cheapest movies
SELECT *
FROM film
ORDER BY rental_rate ASC
LIMIT 10;

-- 11. Find the next 10 cheapest movies
SELECT *
FROM film
ORDER BY rental_rate ASC, film_id ASC
LIMIT 10
OFFSET 10;

-- 11 Bonus: Find the next 10 cheapest movies without LIMIT
-- 11 Bonus: Find the next 10 cheapest movies without LIMIT
SELECT *
FROM (
    SELECT
        film_id,
        title,
        description,
        release_year,
        rental_rate,
        ROW_NUMBER() OVER (
            ORDER BY rental_rate ASC, film_id ASC
        ) AS row_num
    FROM film
) AS ranked_films
WHERE row_num BETWEEN 11 AND 20
ORDER BY row_num;

-- 12. Join customer and payment tables
SELECT
    customer.first_name,
    customer.last_name,
    payment.amount,
    payment.payment_date
FROM customer
JOIN payment
    ON customer.customer_id = payment.customer_id
ORDER BY customer.customer_id ASC;

-- 13. Get all movies that are not in inventory
SELECT *
FROM film
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory
    WHERE inventory.film_id = film.film_id
);

-- 14. Find which city is in which country
SELECT
    city.city,
    country.country
FROM city
JOIN country
    ON city.country_id = country.country_id;

-- 15. Bonus: Customer payment information
-- ordered by the staff member who processed the payment

SELECT
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    payment.amount,
    payment.payment_date
FROM customer
JOIN payment
    ON customer.customer_id = payment.customer_id
ORDER BY payment.staff_id ASC;