-- =====================================================
-- EXERCISE 1: MOVIE RANKINGS AND ANALYSIS
-- =====================================================


-- -----------------------------------------------------
-- Task 1: Rank Movies by Popularity within Each Genre
-- Use RANK() to rank movies by popularity within each genre.
-- -----------------------------------------------------

SELECT
    g.genre_name,
    m.title,
    RANK() OVER (
        PARTITION BY g.genre_name
        ORDER BY m.popularity DESC
    ) AS popularity_rank
FROM movies.movie m
JOIN movies.movie_genres mg
    ON m.movie_id = mg.movie_id
JOIN movies.genre g
    ON mg.genre_id = g.genre_id
ORDER BY g.genre_name, popularity_rank;


-- -----------------------------------------------------
-- Task 2: Divide Movies into Revenue Quartiles
-- within Each Production Company
-- Use NTILE(4) to divide movies into quartiles based on revenue.
-- -----------------------------------------------------

SELECT
    pc.company_name,
    m.title,
    m.revenue,
    NTILE(4) OVER (
        PARTITION BY pc.company_name
        ORDER BY m.revenue DESC
    ) AS revenue_quartile
FROM movies.production_company pc
JOIN movies.movie_company mc
    ON pc.company_id = mc.company_id
JOIN movies.movie m
    ON mc.movie_id = m.movie_id
ORDER BY pc.company_name, revenue_quartile, m.revenue DESC;


-- -----------------------------------------------------
-- Task 3: Calculate the Running Total of Movie Budgets
-- for Each Genre
-- Use SUM() with a ROWS frame specification.
-- -----------------------------------------------------

SELECT
    g.genre_name,
    m.title,
    m.budget,
    SUM(m.budget) OVER (
        PARTITION BY g.genre_name
        ORDER BY m.movie_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_budget
FROM movies.movie m
JOIN movies.movie_genres mg
    ON m.movie_id = mg.movie_id
JOIN movies.genre g
    ON mg.genre_id = g.genre_id
ORDER BY g.genre_name, m.movie_id;


-- -----------------------------------------------------
-- Task 4: Identify the Most Recent Movie for Each Genre
-- Use FIRST_VALUE() based on release date.
-- -----------------------------------------------------

WITH recent_movies AS (
    SELECT
        g.genre_name,
        FIRST_VALUE(m.title) OVER (
            PARTITION BY g.genre_name
            ORDER BY m.release_date DESC
        ) AS movie_title,
        FIRST_VALUE(m.release_date) OVER (
            PARTITION BY g.genre_name
            ORDER BY m.release_date DESC
        ) AS release_date
    FROM movies.movie m
    JOIN movies.movie_genres mg
        ON m.movie_id = mg.movie_id
    JOIN movies.genre g
        ON mg.genre_id = g.genre_id
    WHERE m.release_date IS NOT NULL
)
SELECT DISTINCT
    genre_name,
    movie_title,
    release_date
FROM recent_movies
ORDER BY genre_name;

-- =====================================================
-- EXERCISE 2: CAST AND CREW PERFORMANCE ANALYSIS
-- =====================================================


-- -----------------------------------------------------
-- Task 1: Rank Actors by Their Appearance in Movies
-- Use DENSE_RANK() to rank actors based on the number
-- of movies they have appeared in.
-- -----------------------------------------------------

SELECT
    p.person_name,
    COUNT(DISTINCT mc.movie_id) AS movie_count
FROM movies.person p
JOIN movies.movie_cast mc
    ON p.person_id = mc.person_id
GROUP BY p.person_id, p.person_name
ORDER BY movie_count DESC
LIMIT 20;

WITH actor_movie_counts AS (
    SELECT
        p.person_id,
        p.person_name,
        COUNT(DISTINCT mc.movie_id) AS movie_count
    FROM movies.person p
    JOIN movies.movie_cast mc
        ON p.person_id = mc.person_id
    GROUP BY p.person_id, p.person_name
)
SELECT
    person_name,
    movie_count,
    DENSE_RANK() OVER (
        ORDER BY movie_count DESC
    ) AS appearance_rank
FROM actor_movie_counts
ORDER BY appearance_rank, person_name;

-- -----------------------------------------------------
-- Task 2: Identify the Top Director by Average Movie Rating
-- Use a CTE and RANK() to find the director with the
-- highest average movie rating.
-- -----------------------------------------------------

SELECT *
FROM movies.movie_crew
LIMIT 10;

SELECT
    title,
    vote_average
FROM movies.movie
LIMIT 10;

WITH director_ratings AS (
    SELECT
        p.person_id,
        p.person_name,
        AVG(m.vote_average) AS average_rating
    FROM movies.person p
    JOIN movies.movie_crew mc
        ON p.person_id = mc.person_id
    JOIN movies.movie m
        ON mc.movie_id = m.movie_id
    WHERE mc.job = 'Director'
    GROUP BY p.person_id, p.person_name
),
ranked_directors AS (
    SELECT
        person_name,
        average_rating,
        RANK() OVER (
            ORDER BY average_rating DESC
        ) AS director_rank
    FROM director_ratings
)
SELECT
    person_name,
    ROUND(average_rating, 2) AS average_rating,
    director_rank
FROM ranked_directors
WHERE director_rank = 1;

-- -----------------------------------------------------
-- Task 3: Calculate the Cumulative Revenue of Movies
-- Acted by Each Actor
-- Use SUM() to calculate cumulative movie revenue
-- for each actor.
-- -----------------------------------------------------

SELECT
    p.person_name,
    m.title,
    m.revenue
FROM movies.person p
JOIN movies.movie_cast mc
    ON p.person_id = mc.person_id
JOIN movies.movie m
    ON mc.movie_id = m.movie_id
WHERE m.revenue IS NOT NULL
ORDER BY p.person_name, m.movie_id
LIMIT 20;

SELECT
    p.person_name,
    m.title,
    m.revenue,
    SUM(m.revenue) OVER (
        PARTITION BY p.person_id
        ORDER BY m.movie_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM movies.person p
JOIN movies.movie_cast mc
    ON p.person_id = mc.person_id
JOIN movies.movie m
    ON mc.movie_id = m.movie_id
WHERE m.revenue IS NOT NULL
ORDER BY p.person_name, m.movie_id;

-- -----------------------------------------------------
-- Task 4: Identify the Director Whose Movies Have
-- the Highest Total Budget
-- Use a CTE and a window function to find the director
-- whose movies have the highest total budget.
-- -----------------------------------------------------

SELECT
    p.person_name,
    SUM(m.budget) AS total_budget
FROM movies.person p
JOIN movies.movie_crew mc
    ON p.person_id = mc.person_id
JOIN movies.movie m
    ON mc.movie_id = m.movie_id
WHERE mc.job = 'Director'
GROUP BY p.person_id, p.person_name
ORDER BY total_budget DESC
LIMIT 20;

WITH director_budgets AS (
    SELECT
        p.person_id,
        p.person_name,
        SUM(m.budget) AS total_budget
    FROM movies.person p
    JOIN movies.movie_crew mc
        ON p.person_id = mc.person_id
    JOIN movies.movie m
        ON mc.movie_id = m.movie_id
    WHERE mc.job = 'Director'
    GROUP BY p.person_id, p.person_name
),
ranked_directors AS (
    SELECT
        person_name,
        total_budget,
        RANK() OVER (
            ORDER BY total_budget DESC
        ) AS budget_rank
    FROM director_budgets
)
SELECT
    person_name,
    total_budget
FROM ranked_directors
WHERE budget_rank = 1;