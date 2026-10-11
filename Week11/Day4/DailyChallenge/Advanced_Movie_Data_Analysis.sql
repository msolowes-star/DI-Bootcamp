-- ============================================================
-- DAILY CHALLENGE: ADVANCED MOVIE DATA ANALYSIS
-- PostgreSQL | Movies database | Schema: movies
-- ============================================================
-- Run each task separately in pgAdmin, or run this entire file.
-- Assumptions: budgets and revenues greater than zero are valid;
-- zero values are treated as missing/unusable financial data.

-- TASK 1: Average budget growth rate by production company
-- LAG() gets the previous qualifying movie budget in release order.
-- The first qualifying movie per company has no growth rate.
WITH budget_history AS (
    SELECT
        pc.company_id,
        pc.company_name,
        m.title,
        m.release_date,
        m.budget,
        LAG(m.budget) OVER (
            PARTITION BY pc.company_id
            ORDER BY m.release_date, m.movie_id
        ) AS previous_budget
    FROM movies.movie AS m
    JOIN movies.movie_company AS mc ON m.movie_id = mc.movie_id
    JOIN movies.production_company AS pc ON mc.company_id = pc.company_id
    WHERE m.budget > 0
),
budget_growth AS (
    SELECT
        company_id,
        company_name,
        title,
        budget,
        previous_budget,
        ROUND(
            (budget - previous_budget) * 100.0 /
            NULLIF(previous_budget, 0), 2
        ) AS growth_rate
    FROM budget_history
)
SELECT
    company_name,
    ROUND(AVG(growth_rate), 2) AS avg_budget_growth_rate
FROM budget_growth
GROUP BY company_id, company_name
ORDER BY avg_budget_growth_rate DESC NULLS LAST;
-- Note: very small earlier budgets can produce extremely high growth rates.
-- Companies with only one qualifying movie have a NULL average.


-- TASK 2: Actor with the most above-average-rated movies
-- AVG() OVER () computes the overall movie rating benchmark.
-- RANK() includes ties for first place.
WITH movie_ratings AS (
    SELECT
        movie_id,
        title,
        vote_average,
        AVG(vote_average) OVER () AS overall_avg_rating
    FROM movies.movie
    WHERE vote_average IS NOT NULL
),
high_rated_movies AS (
    SELECT movie_id, title, vote_average
    FROM movie_ratings
    WHERE vote_average > overall_avg_rating
),
actor_counts AS (
    SELECT
        p.person_id,
        p.person_name,
        COUNT(DISTINCT hr.movie_id) AS high_rated_movie_count
    FROM high_rated_movies AS hr
    JOIN movies.movie_cast AS mc ON hr.movie_id = mc.movie_id
    JOIN movies.person AS p ON mc.person_id = p.person_id
    GROUP BY p.person_id, p.person_name
),
ranked_actors AS (
    SELECT
        person_name,
        high_rated_movie_count,
        RANK() OVER (ORDER BY high_rated_movie_count DESC) AS actor_rank
    FROM actor_counts
)
SELECT person_name, high_rated_movie_count, actor_rank
FROM ranked_actors
WHERE actor_rank = 1;
-- Observed result: Samuel L. Jackson | 45 movies | rank 1.


-- TASK 3: Three-movie rolling average revenue by genre
-- The window includes the current movie and up to two preceding
-- qualifying movies within the same genre, in release-date order.
SELECT
    g.genre_name,
    m.title AS movie_title,
    m.release_date,
    m.revenue,
    ROUND(
        AVG(m.revenue) OVER (
            PARTITION BY g.genre_id
            ORDER BY m.release_date, m.movie_id
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS rolling_avg_revenue
FROM movies.movie AS m
JOIN movies.movie_genres AS mg ON m.movie_id = mg.movie_id
JOIN movies.genre AS g ON mg.genre_id = g.genre_id
WHERE m.revenue > 0
  AND m.release_date IS NOT NULL
ORDER BY g.genre_name, m.release_date, m.movie_id;
-- Observed output: 8,898 rows.


-- TASK 4: Highest-grossing keyword-based movie group
-- Shared keywords are used as a proxy for 'series' because this
-- database exercise does not provide an explicit franchise mapping.
-- IMPORTANT: A keyword can cover unrelated movies; therefore the
-- result is NOT necessarily the highest-grossing real-world franchise.
WITH series_revenue AS (
    SELECT
        k.keyword_id,
        k.keyword_name AS movie_series,
        COUNT(DISTINCT m.movie_id) AS movie_count,
        SUM(m.revenue) AS total_revenue
    FROM movies.movie AS m
    JOIN movies.movie_keywords AS mk ON m.movie_id = mk.movie_id
    JOIN movies.keyword AS k ON mk.keyword_id = k.keyword_id
    WHERE m.revenue > 0
    GROUP BY k.keyword_id, k.keyword_name
    HAVING COUNT(DISTINCT m.movie_id) > 1
),
ranked_series AS (
    SELECT
        movie_series,
        movie_count,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM series_revenue
)
SELECT movie_series, movie_count, total_revenue, revenue_rank
FROM ranked_series
WHERE revenue_rank = 1;
-- Observed result: duringcreditsstinger | 278 movies |
-- 57,827,617,707 total revenue | rank 1.
-- 'duringcreditsstinger' describes a film feature, not a franchise.
