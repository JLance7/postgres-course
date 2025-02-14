-- operators: comparison, logical, arithmetic
SELECT * FROM movies;

SELECT * FROM movies
WHERE movie_language = 'English' AND age_certification = '18';

SELECT *
FROM directors
WHERE nationality = 'American'
ORDER BY date_of_birth ASC
LIMIT 5
OFFSET 5;

SELECT *
FROM movies
FETCH FIRST 5 ROW ONLY;

-- biggest movies by movie length
SELECT *
FROM movies
ORDER BY movie_length DESC
FETCH FIRST 5 ROWS ONLY;

-- top 5 oldest American directors
SELECT *
FROM directors
WHERE nationality = 'American'
ORDER BY date_of_birth DESC
FETCH FIRST 5 ROW ONLY;

SELECT * 
FROM movies
WHERE movie_language in ('English', 'Chinese', 'Japanse');

SELECT *
FROM actors
WHERE date_of_birth BETWEEN '1991-01-01' AND '1995-12-31';

SELECT *
FROM movies
WHERE movie_length BETWEEN 100 AND 200
ORDER BY movie_length;

-- get all actors where first name starts with 'A'
SELECT *
FROM actors
WHERE first_name LIKE 'A%'
ORDER BY first_name;

SELECT *
FROM actors
WHERE first_name LIKE '______'
ORDER BY first_name;


-- ILIKE is not case sensitive