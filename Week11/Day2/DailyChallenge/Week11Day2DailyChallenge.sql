SELECT
    gc.person_id,
    g.season,
    COUNT(*) AS medal_count
FROM olympics.games_competitor gc
JOIN olympics.games g
    ON gc.games_id = g.id
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id, g.season
ORDER BY gc.person_id
LIMIT 30;

SELECT
    gc.person_id
FROM olympics.games_competitor gc
JOIN olympics.games g
    ON gc.games_id = g.id
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id
HAVING COUNT(DISTINCT g.season) = 2
ORDER BY gc.person_id;

CREATE TEMP TABLE summer_winter_medalists (
    person_id INT,
    full_name VARCHAR(500),
    summer_medals INT,
    winter_medals INT
);

INSERT INTO summer_winter_medalists
    (person_id, full_name, summer_medals, winter_medals)
SELECT
    p.id,
    p.full_name,
    SUM(CASE WHEN g.season = 'Summer' THEN 1 ELSE 0 END) AS summer_medals,
    SUM(CASE WHEN g.season = 'Winter' THEN 1 ELSE 0 END) AS winter_medals
FROM olympics.person p
JOIN olympics.games_competitor gc
    ON p.id = gc.person_id
JOIN olympics.games g
    ON gc.games_id = g.id
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
WHERE ce.medal_id <> 4
AND p.id IN (
    SELECT gc2.person_id
    FROM olympics.games_competitor gc2
    JOIN olympics.games g2
        ON gc2.games_id = g2.id
    JOIN olympics.competitor_event ce2
        ON gc2.id = ce2.competitor_id
    WHERE ce2.medal_id <> 4
    GROUP BY gc2.person_id
    HAVING COUNT(DISTINCT g2.season) = 2
)
GROUP BY p.id, p.full_name;

SELECT *
FROM summer_winter_medalists
ORDER BY summer_medals + winter_medals DESC;

SELECT *
FROM olympics.sport
LIMIT 10;

SELECT
    gc.person_id,
    COUNT(DISTINCT e.sport_id) AS sports_with_medals,
    COUNT(*) AS total_medals
FROM olympics.games_competitor gc
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
JOIN olympics.event e
    ON ce.event_id = e.id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id
HAVING COUNT(DISTINCT e.sport_id) = 2
ORDER BY total_medals DESC
LIMIT 20;

CREATE TEMP TABLE two_sport_medalists AS
SELECT
    gc.person_id,
    p.full_name,
    COUNT(DISTINCT e.sport_id) AS sports_with_medals,
    COUNT(*) AS total_medals
FROM olympics.games_competitor gc
JOIN olympics.person p
    ON gc.person_id = p.id
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
JOIN olympics.event e
    ON ce.event_id = e.id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id, p.full_name
HAVING COUNT(DISTINCT e.sport_id) = 2;

SELECT *
FROM two_sport_medalists
WHERE person_id IN (
    SELECT person_id
    FROM two_sport_medalists
    ORDER BY total_medals DESC
    LIMIT 3
)
ORDER BY total_medals DESC;

SELECT
    gc.person_id,
    ce.event_id,
    COUNT(*) AS medals_in_event
FROM olympics.games_competitor gc
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
WHERE ce.medal_id <> 4
GROUP BY gc.person_id, ce.event_id
ORDER BY medals_in_event DESC
LIMIT 20;

SELECT
    person_id,
    MAX(medals_in_event) AS max_medals_single_event
FROM (
    SELECT
        gc.person_id,
        ce.event_id,
        COUNT(*) AS medals_in_event
    FROM olympics.games_competitor gc
    JOIN olympics.competitor_event ce
        ON gc.id = ce.competitor_id
    WHERE ce.medal_id <> 4
    GROUP BY gc.person_id, ce.event_id
) AS event_medal_counts
GROUP BY person_id
ORDER BY max_medals_single_event DESC
LIMIT 20;

SELECT
    nr.region_name,
    SUM(competitor_max.max_medals_single_event) AS total_medals
FROM (
    SELECT
        person_id,
        MAX(medals_in_event) AS max_medals_single_event
    FROM (
        SELECT
            gc.person_id,
            ce.event_id,
            COUNT(*) AS medals_in_event
        FROM olympics.games_competitor gc
        JOIN olympics.competitor_event ce
            ON gc.id = ce.competitor_id
        WHERE ce.medal_id <> 4
        GROUP BY gc.person_id, ce.event_id
    ) AS event_medal_counts
    GROUP BY person_id
) AS competitor_max
JOIN olympics.person_region pr
    ON competitor_max.person_id = pr.person_id
JOIN olympics.noc_region nr
    ON pr.region_id = nr.id
GROUP BY nr.region_name
ORDER BY total_medals DESC
LIMIT 5;

SELECT
    gc.person_id,
    COUNT(DISTINCT gc.games_id) AS games_participated
FROM olympics.games_competitor gc
GROUP BY gc.person_id
HAVING COUNT(DISTINCT gc.games_id) > 3
ORDER BY games_participated DESC
LIMIT 20;

SELECT
    gc.person_id,
    COUNT(DISTINCT gc.games_id) AS games_participated
FROM olympics.games_competitor gc
WHERE gc.person_id NOT IN (
    SELECT DISTINCT gc2.person_id
    FROM olympics.games_competitor gc2
    JOIN olympics.competitor_event ce2
        ON gc2.id = ce2.competitor_id
    WHERE ce2.medal_id <> 4
)
GROUP BY gc.person_id
HAVING COUNT(DISTINCT gc.games_id) > 3
ORDER BY games_participated DESC
LIMIT 20;

CREATE TEMP TABLE frequent_non_medalists AS
SELECT
    gc.person_id,
    p.full_name,
    COUNT(DISTINCT gc.games_id) AS games_participated
FROM olympics.games_competitor gc
JOIN olympics.person p
    ON gc.person_id = p.id
WHERE gc.person_id NOT IN (
    SELECT DISTINCT gc2.person_id
    FROM olympics.games_competitor gc2
    JOIN olympics.competitor_event ce2
        ON gc2.id = ce2.competitor_id
    WHERE ce2.medal_id <> 4
)
GROUP BY gc.person_id, p.full_name
HAVING COUNT(DISTINCT gc.games_id) > 3;

SELECT *
FROM frequent_non_medalists
ORDER BY games_participated DESC, full_name;