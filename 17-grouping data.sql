-- GROUP BY divides the rows returned from the SELECT statement into groups
-- For each group you can apply an aggregate function like COUNT, SUM, MIN, MAX

/*
SELECT
	col1,
	AGGREGATE_FUNCTION(col2)
FROM table
GROUP BY
	col1;
*/

-- GROUP BY eliminates duplicate values from result, like DISTINCT

-- get total count of all movies group by movie language
SELECT
	COUNT(*),
	movie_language
FROM movies
GROUP BY
	movie_language
ORDER BY 1 DESC;

-- average movie length for each movie language
SELECT
	movie_language,
	AVG(movie_length)
FROM
	movies
GROUP BY
	movie_language
ORDER BY 
	2 DESC;
	
-- SUM total movie length per age certificate
SELECT
	age_certification,
	SUM(movie_length)
FROM movies
GROUP BY
	age_certification
ORDER BY
	2 DESC;
	
-- min and max movie length for each movie language
SELECT
	MIN(movie_length),
	MAX(movie_length),
	movie_language
FROM 
	movies
GROUP BY
	movie_language;
	
-- average movie length per language and certification combination
SELECT
	AVG(movie_length),
	age_certification,
	movie_language
FROM movies
WHERE 
	movie_length > 100
GROUP BY
	2, 3
ORDER BY
	3;
	
	
SELECT
	AVG(movie_length),
	age_certification,
	movie_language
FROM movies
WHERE 
	movie_length > 100
GROUP BY
	2, 3, movie_length
ORDER BY
	movie_length;
	
-- how many directors per nationality
SELECT
	COUNT(*) AS "number_of_directors",
	nationality
FROM directors
GROUP BY
	nationality
ORDER BY 1 DESC;

-- total movie length for each age certification
SELECT
	SUM(movie_length),
	movie_language,
	age_certification
FROM movies
GROUP BY movie_language, age_certification
ORDER BY 1 DESC;

/*
-- order
FROM
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
ORDER BY
LIMIT
*/

-- having clause for search condition in group by aggregate functions

-- list movie languages where sum of total movie length >= 200
SELECT
	SUM(movie_length),
	movie_language
FROM movies
GROUP BY movie_language
HAVING SUM(movie_length) > 200 -- filter on result from sum
ORDER BY SUM(movie_length);

-- having filters result group aggregate data
-- where works on select columns

SELECT
	SUM(movie_length),
	movie_language
FROM movies
WHERE movie_length > 100 -- only sum movie where movie_length > 100
GROUP BY movie_language
ORDER BY SUM(movie_length);

CREATE TABLE employees_test(
	employee_id SERIAL PRIMARY KEY,
	employee_name VARCHAR(100),
	department VARCHAR(100),
	salary INT
);

INSERT INTO employees_test
	(employee_name, department, salary)
VALUES
	('John', 'Finance', 2500),
	('Mary', NULL, 3000),
	('Adam', NULL, 4000),
	('Bruce', 'Finance', 4000),
	('Linda', 'IT', 4000),
	('Megan', 'IT', 4000);
	
SELECT * FROM employees_test
ORDER BY department;

-- total # of employees for each group
SELECT
	COUNT(*),
	COALESCE(department, 'No Department') AS department
FROM employees_test
GROUP BY department
ORDER BY department;