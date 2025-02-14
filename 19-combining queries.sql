-- union operator combines results sets from two or more select statements
-- order and number of columns in select queries must be the same, data types must be compatible too
SELECT
	product_id, product_name
FROM left_products
UNION
SELECT
	product_id, product_name
FROM right_products; -- gives unique records between 2 tables

SELECT
	first_name,
	last_name,
	'actors' AS "table_name"
FROM actors
UNION
SELECT
	first_name,
	last_name,
	'directors' AS "directors"
FROM directors;

-- INTERSECT returns rows that are available in BOTH result sets
SELECT
	*
FROM left_products
INTERSECT
SELECT 
	*
FROM right_products;

-- find people that were both directors and actors
SELECT first_name, last_name
FROM directors
INTERSECT
SELECT first_name, last_name
FROM actors; -- Bruce Lee and Terry Jones

-- find the movies where they were directors
SELECT
	*
FROM directors d
JOIN movies m ON d.director_id = m.movie_id
WHERE d.first_name = 'Bruce' AND d.last_name = 'Lee';

-- find the movies where they were actors
SELECT
	m.movie_name,
	a.first_name,
	a.last_name
FROM movies_actors ma
JOIN movies m ON ma.movie_id = m.movie_id
JOIN actors a ON ma.actor_id = a.actor_id
WHERE a.first_name = 'Bruce' AND a.last_name = 'Lee';

SELECT * FROM actors a WHERE a.first_name = 'Bruce' AND a.last_name = 'Lee';
SELECT * FROM movies_actors WHERE actor_id = 82;

-- EXCEPT returns rows in first query that do not appear in the output of the second query
SELECT * FROM left_products EXCEPT SELECT * FROM right_products;