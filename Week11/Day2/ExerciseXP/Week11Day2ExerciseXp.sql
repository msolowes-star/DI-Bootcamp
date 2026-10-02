SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'olympics'
ORDER BY table_name;

SELECT COUNT(*) AS people FROM olympics.person;

SELECT COUNT(*) AS competitors FROM olympics.games_competitor;

SELECT COUNT(*) AS competitor_events FROM olympics.competitor_event;

SELECT COUNT(*) AS events FROM olympics.event;

SELECT *
FROM olympics.competitor_event
LIMIT 10;

SELECT *
FROM olympics.games_competitor
LIMIT 10;

SELECT 
    gc.id AS competitor_id,
    gc.age,
    ce.medal_id
FROM olympics.games_competitor gc
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
LIMIT 20;

SELECT 
    gc.id AS competitor_id,
    gc.age,
    ce.medal_id
FROM olympics.games_competitor gc
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
WHERE ce.medal_id <> 4
LIMIT 20;

SELECT 
    gc.id AS competitor_id,
    gc.age,
    m.medal_name
FROM olympics.games_competitor gc
JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
JOIN olympics.medal m
    ON ce.medal_id = m.id
WHERE ce.medal_id <> 4
LIMIT 20;

SELECT
    m.medal_name,
    (
        SELECT AVG(gc.age)
        FROM olympics.games_competitor gc
        JOIN olympics.competitor_event ce
            ON gc.id = ce.competitor_id
        WHERE ce.medal_id = m.id
    ) AS average_age
FROM olympics.medal m
WHERE m.medal_name <> 'NA';

SELECT *
FROM olympics.person_region
LIMIT 10;

SELECT *
FROM olympics.noc_region
LIMIT 10;

SELECT
    competitor_id,
    COUNT(DISTINCT event_id) AS event_count
FROM olympics.competitor_event
GROUP BY competitor_id
HAVING COUNT(DISTINCT event_id) > 3
LIMIT 20;

SELECT
    gc.id AS competitor_id,
    gc.person_id,
    gc.games_id
FROM olympics.games_competitor gc
WHERE gc.id IN (
    SELECT competitor_id
    FROM olympics.competitor_event
    GROUP BY competitor_id
    HAVING COUNT(DISTINCT event_id) > 3
)
LIMIT 20;

SELECT
    nr.region_name,
    COUNT(DISTINCT gc.person_id) AS unique_competitors
FROM olympics.games_competitor gc
JOIN olympics.person_region pr
    ON gc.person_id = pr.person_id
JOIN olympics.noc_region nr
    ON pr.region_id = nr.id
WHERE gc.id IN (
    SELECT competitor_id
    FROM olympics.competitor_event
    GROUP BY competitor_id
    HAVING COUNT(DISTINCT event_id) > 3
)
GROUP BY nr.region_name
ORDER BY unique_competitors DESC
LIMIT 5;

SELECT
    competitor_id,
    COUNT(*) AS total_medals
FROM olympics.competitor_event
WHERE medal_id <> 4
GROUP BY competitor_id
ORDER BY total_medals DESC
LIMIT 20;

CREATE TEMP TABLE competitor_medals AS
SELECT
    competitor_id,
    COUNT(*) AS total_medals
FROM olympics.competitor_event
WHERE medal_id <> 4
GROUP BY competitor_id;

SELECT *
FROM competitor_medals
WHERE competitor_id IN (
    SELECT competitor_id
    FROM competitor_medals
    WHERE total_medals > 2
)
ORDER BY total_medals DESC;

CREATE TEMP TABLE competitor_analysis AS
SELECT DISTINCT
    gc.id AS competitor_id,
    gc.person_id
FROM olympics.games_competitor gc;

DELETE FROM competitor_analysis
WHERE competitor_id NOT IN (
    SELECT DISTINCT competitor_id
    FROM olympics.competitor_event
    WHERE medal_id <> 4
);

SELECT COUNT(*) AS remaining_medal_winners
FROM competitor_analysis;

SELECT *
FROM olympics.person
LIMIT 10;

CREATE TEMP TABLE person_height_analysis AS
SELECT *
FROM olympics.person;

UPDATE person_height_analysis p
SET height = (
    SELECT ROUND(AVG(p2.height))
    FROM person_height_analysis p2
    JOIN olympics.person_region pr2
        ON p2.id = pr2.person_id
    WHERE pr2.region_id = (
        SELECT pr.region_id
        FROM olympics.person_region pr
        WHERE pr.person_id = p.id
        LIMIT 1
    )
    AND p2.height > 0
)
WHERE p.height = 0;

CREATE INDEX idx_person_region_person
ON olympics.person_region(person_id);

CREATE TEMP TABLE region_avg_height AS
SELECT
    pr.region_id,
    ROUND(AVG(p.height)) AS avg_height
FROM person_height_analysis p
JOIN olympics.person_region pr
    ON p.id = pr.person_id
WHERE p.height > 0
GROUP BY pr.region_id;

UPDATE person_height_analysis p
SET height = (
    SELECT rah.avg_height
    FROM region_avg_height rah
    WHERE rah.region_id = (
        SELECT pr.region_id
        FROM olympics.person_region pr
        WHERE pr.person_id = p.id
        LIMIT 1
    )
)
WHERE p.height = 0;

SELECT
    id,
    full_name,
    height
FROM person_height_analysis
WHERE id IN (3, 4);

SELECT
    competitor_id,
    COUNT(DISTINCT event_id) AS total_events
FROM olympics.competitor_event
GROUP BY competitor_id
HAVING COUNT(DISTINCT event_id) > 1
ORDER BY total_events DESC
LIMIT 20;

CREATE TEMP TABLE multi_event_competitors (
    competitor_id INT,
    person_id INT,
    games_id INT,
    total_events INT
);

INSERT INTO multi_event_competitors
    (competitor_id, person_id, games_id, total_events)
SELECT
    gc.id,
    gc.person_id,
    gc.games_id,
    (
        SELECT COUNT(DISTINCT ce.event_id)
        FROM olympics.competitor_event ce
        WHERE ce.competitor_id = gc.id
    ) AS total_events
FROM olympics.games_competitor gc
WHERE gc.id IN (
    SELECT competitor_id
    FROM (
        SELECT
            competitor_id,
            COUNT(DISTINCT event_id) AS event_count
        FROM olympics.competitor_event
        GROUP BY competitor_id
        HAVING COUNT(DISTINCT event_id) > 1
    ) AS qualifying_competitors
);

CREATE TEMP TABLE competitor_event_counts AS
SELECT
    competitor_id,
    COUNT(DISTINCT event_id) AS total_events
FROM olympics.competitor_event
GROUP BY competitor_id;

INSERT INTO multi_event_competitors
    (competitor_id, person_id, games_id, total_events)
SELECT
    gc.id,
    gc.person_id,
    gc.games_id,
    cec.total_events
FROM olympics.games_competitor gc
JOIN competitor_event_counts cec
    ON gc.id = cec.competitor_id
WHERE gc.id IN (
    SELECT competitor_id
    FROM (
        SELECT competitor_id
        FROM competitor_event_counts
        WHERE total_events > 1
    ) AS qualifying_competitors
);

SELECT *
FROM multi_event_competitors
ORDER BY total_events DESC
LIMIT 20;

CREATE TEMP TABLE all_competitor_medals AS
SELECT
    gc.id AS competitor_id,
    gc.person_id,
    COUNT(ce.medal_id) FILTER (WHERE ce.medal_id <> 4) AS total_medals
FROM olympics.games_competitor gc
LEFT JOIN olympics.competitor_event ce
    ON gc.id = ce.competitor_id
GROUP BY gc.id, gc.person_id;

SELECT
    AVG(total_medals) AS overall_average_medals
FROM all_competitor_medals;

SELECT
    nr.region_name,
    AVG(acm.total_medals) AS average_medals
FROM all_competitor_medals acm
JOIN olympics.person_region pr
    ON acm.person_id = pr.person_id
JOIN olympics.noc_region nr
    ON pr.region_id = nr.id
GROUP BY nr.region_name
ORDER BY average_medals DESC;

SELECT
    nr.region_name,
    AVG(acm.total_medals) AS average_medals
FROM all_competitor_medals acm
JOIN olympics.person_region pr
    ON acm.person_id = pr.person_id
JOIN olympics.noc_region nr
    ON pr.region_id = nr.id
GROUP BY nr.region_name
HAVING AVG(acm.total_medals) > (
    SELECT AVG(total_medals)
    FROM all_competitor_medals
)
ORDER BY average_medals DESC;

SELECT *
FROM olympics.games
LIMIT 10;

CREATE TEMP TABLE competitor_seasons AS
SELECT DISTINCT
    gc.person_id,
    g.season
FROM olympics.games_competitor gc
JOIN olympics.games g
    ON gc.games_id = g.id;

SELECT
    person_id
FROM competitor_seasons
GROUP BY person_id
HAVING COUNT(DISTINCT season) = 2
ORDER BY person_id;

SELECT
    p.id AS person_id,
    p.full_name
FROM olympics.person p
WHERE p.id IN (
    SELECT person_id
    FROM competitor_seasons
    GROUP BY person_id
    HAVING COUNT(DISTINCT season) = 2
)
ORDER BY p.full_name;