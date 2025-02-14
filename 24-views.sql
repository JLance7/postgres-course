-- shortcut for long sql query
-- stored query, virtual table

-- A view can be used to query the view (virtual table of stored sql statement) or 
-- use the view to insert or update data into a table it's based on

-- regular views do not store any data except materialized views

CREATE OR REPLACE VIEW v_movie_quick AS
SELECT
	movie_name,
	movie_length,
	release_date
FROM movies;

SELECT * FROM v_movie_quick;

DROP VIEW v_movies_directors_all;
CREATE OR REPLACE VIEW v_movies_directors_all AS	
SELECT 
	m.movie_id, 
	m.movie_name,
	m.movie_length,
	m.movie_language,
	m.age_certification,
	m.release_date,
	d.director_id,
	d.first_name || ' ' || d.last_name AS director_name,
	d.date_of_birth,
	d.nationality
FROM movies m
INNER JOIN directors d on m.director_id = m.director_id;


SELECT * FROM v_movies_directors_all;

ALTER VIEW v_movie_quick2 RENAME TO v_movie_quick;
GRANT SELECT ON v_movie_quick TO adam;

DROP VIEW v_movie_quick;

CREATE OR REPLACE VIEW v_movies_after_1997 AS
SELECT *
FROM movies
WHERE release_date >= '1996-12-31'
ORDER BY release_date DESC;


SELECT *
FROM v_movies_after_1997
WHERE movie_language = 'English'
AND age_certification = '12';

SELECT * 
FROM movies m
INNER JOIN directors d
	ON m.director_id = d.director_id
WHERE d.nationality IN ('Japanese', 'American');

SELECT *
FROM v_movies_directors_all
WHERE nationality IN ('Japanese', 'American');

CREATE VIEW v_all_actors_directors AS
SELECT
	first_name,
	last_name,
	'actor' AS "people_type"
FROM actors
UNION
SELECT
	first_name,
	last_name,
	'director' AS "people_type"
FROM directors;

SELECT *
FROM v_all_actors_directors
WHERE first_name = 'John'
ORDER BY people_type;


CREATE OR REPLACE VIEW v_movie_directors_revenues AS
SELECT 
	m.movie_id,
	m.movie_name,
	m.movie_length,
	d.nationality,
	mr.revenues_domestic
FROM movies m
INNER JOIN directors d
	ON m.director_id = d.director_id
INNER JOIN movies_revenues mr
	ON m.movie_id = mr.movie_id;
	
SELECT * FROM v_movie_directors_revenues
WHERE nationality = 'American';


-- updatable view
CREATE OR REPLACE VIEW vu_directors AS
SELECT
	first_name,
	last_name
FROM directors;

INSERT INTO vu_directors (first_name) 
VALUES
	('dir1'), ('dir2');
	
SELECT * FROM vu_directors;

DELETE FROM vu_directors
WHERE first_name = 'dir1';

CREATE TABLE countries (
	country_id SERIAL PRIMARY KEY,
	country_code VARCHAR(4),
	city_name VARCHAR(100)
);
--DROP TABLE countries;
INSERT INTO countries (country_code, city_name)
VALUES
	('US', 'New York'),
	('US', 'New Jersey'),
	('UK', 'London');
--DELETE FROM countries WHERE city_name = 'London';	
SELECT * FROM countries;

CREATE VIEW v_cities_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE country_code = 'US';

SELECT * FROM v_cities_us;

INSERT INTO v_cities_us (country_code, city_name)
VALUES
	('US', 'Las Angeles');
	

CREATE OR REPLACE VIEW v_cities_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE country_code = 'US'
WITH CHECK OPTION;

INSERT INTO v_cities_us (country_code, city_name)
VALUES
	('UK', 'Manchester');
	
	
CREATE OR REPLACE VIEW v_cities_c AS
SELECT *
FROM countries
WHERE city_name LIKE 'C%';

CREATE OR REPLACE VIEW v_cities_c_us AS
SELECT * 
FROM v_cities_c
WHERE country_code = 'US'
WITH LOCAL CHECK OPTION;
-- WITH CASCADED CHECK OPTION (goes up)

-- materialized view
-- store data physically, update the data periodically
-- Executes query once and holds result until you refresh material view again
-- pay for freshness in execution time

-- if you want to pass data into materialized view at creation time you use WITH DATA option
-- materialized views can be used to cache results of a heavy query
DROP MATERIALIZED VIEW mv_directors;

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS
SELECT
	director_id,
	first_name,
	last_name
FROM directors
WITH DATA;

SELECT * FROM mv_directors;

REFRESH MATERIALIZED VIEW mv_directors;

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_directors; -- updates view without locking table

DROP MATERIALIZED VIEW mv_directors;

INSERT INTO directors (first_name)
VALUES ('dir1'), ('dir2');

CREATE UNIQUE INDEX idx_u_mv_directors_director_id ON mv_directors (director_id); -- requirement for CONCURRENTLY

-- check if populated
SELECT relispopulated FROM pg_class WHERE relname = 'mv_directors';

-- major benefit of MV over table is ability to refresh it without locking everyone out

-- how to use table method without locking
CREATE TABLE temp_table LIKE directors;

INSERT INTO temp_table () VALUES ();

DROP TABLE directors;

ALTER TABLE tempt_table RENAME TO directors;

-- vs
CREATE MATERIALIZED VIEW mv_directors AS ...;
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_directors;

-- use case MV for website page click analytics
CREATE TABLE page_clicks (
	rec_id SERIAL PRIMARY KEY,
	page VARCHAR(200),
	click_time TIMESTAMP,
	user_id BIGINT
);

INSERT INTO page_clicks (page, click_time, user_id) -- 1k rows of fake data
SELECT 
	(
		CASE (RANDOM() * 2)::INT
			WHEN 0 THEN 'one.com'
			WHEN 1 THEN 'two.com'
			WHEN 2 THEN 'three.com'
		END
	) AS page,
	NOW() AS click_time,
	(FLOOR(random() * (1001) + 1))::INT AS user_id
FROM GENERATE_SERIES(1, 1000) seq;

SELECT * FROM page_clicks;
TRUNCATE page_clicks;

-- analyze daily trend, how many pages were clicked per day
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_page_clicks AS
SELECT
	DATE_TRUNC('day', click_time) AS "day",
	page,
	COUNT(*) AS total_clicks
FROM page_clicks
GROUP BY day, page
WITH DATA;

SELECT * FROM mv_page_clicks;

-- daily
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_page_clicks_daily AS
SELECT
	DATE_TRUNC('day', click_time) AS "day",
	page,
	COUNT(*) AS total_clicks
FROM page_clicks
WHERE
	click_time >= DATE_TRUNC('day', NOW())
	AND click_time < TIMESTAMP 'tomorrow'
GROUP BY day, page
WITH DATA;

SELECT * FROM mv_page_clicks_daily;

CREATE UNIQUE INDEX idx_u_mv_page_clicks_daily ON mv_page_clicks_daily (day, page);
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_page_clicks_daily;

-- list MVs
SELECT oid::regclass::text
FROM pg_class


WHERE relkind = 'm';