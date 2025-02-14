SELECT * FROM movies;

SELECT first_name FROM actors;

SELECT * FROM actors
ORDER BY first_name;

SELECT
	first_name AS "First Name"
FROM actors;

SELECT 
	first_name || ' ' || last_name AS "Full Name"
FROM actors;

SELECT
	first_name,
	date_of_birth,
	LENGTH(first_name) AS "length"
FROM actors
ORDER BY 
	date_of_birth ASC NULLS FIRST,
	"length" DESC;
	
SELECT
	first_name,
	date_of_birth,
	LENGTH(first_name) AS "length"
FROM actors
ORDER BY 
	2 ASC,
	3 DESC;
	
SELECT DISTINCT(movie_language) FROM movies ORDER BY 1;

-- distinct combination on multiple columns
SELECT
	DISTINCT movie_language, director_id
FROM movies
ORDER BY movie_language;