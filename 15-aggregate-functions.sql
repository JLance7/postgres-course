SELECT COUNT(*)
FROM movies;

SELECT COUNT(movie_length)
FROM movies;

SELECT COUNT(movie_language)
FROM movies;

SELECT COUNT(DISTINCT(movie_language))
FROM movies;

SELECT
	COUNT(*)
FROM movies
WHERE 
	movie_language = 'English';
	
/*
SELECT boss.boss_id, COUNT(subordinate.1)
FROM boss
LEFT JOIN subordinate on subordinate.boss_id = boss.boss_id
GROUP BY boss.id

Count number of subordiates for each boss
*/

SELECT SUM(revenues_domestic) FROM movies_revenues;

SELECT
	SUM(DISTINCT revenues_domestic)
FROM
	movies_revenues;
	
SELECT
	MIN(revenues_domestic),
	MAX(revenues_domestic)
FROM movies_revenues;

SELECT 
	movie_length
FROM movies
ORDER BY movie_length DESC;

SELECT
	*
FROM 
	movies
WHERE
	movie_language = 'English'
ORDER BY
	release_date DESC;
	
SELECT
	MAX(release_date)
FROM movies;

SELECT GREATEST(10, 20, 30);

SELECT
	AVG(movie_length)
FROM movies;


SELECT 10 % 5;

SELECT
	movie_id,
	revenues_domestic,
	revenues_international,
	(revenues_domestic + revenues_international) AS total
FROM movies_revenues
ORDER BY 4 DESC
NULLS LAST;


