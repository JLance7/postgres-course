-- a subquery is typically used for a calculation to provide data to the main query, enclosed in ()
-- can be used in SELECT, INSERT, UPDATE, or DELTE
-- can also be used in FROM, WHERE

-- filtering with subqueries in WHERE clause

--- find movies average movie length, then use results from first query and SELECT to find movies which are more than average movie length
SELECT
	AVG(movie_length)
FROM movies;

SELECT COUNT(*) FROM movies;


SELECT
	movie_name,
	movie_length
FROM movies
WHERE movie_length > (
	SELECT
		AVG(movie_length)
	FROM movies
)
ORDER BY movie_length DESC;

-- get first and last names of all actors who are younger than Douglas Silva
SELECT
	first_name,
	last_name,
	date_of_birth
FROM actors
WHERE date_of_birth > (
	SELECT
		date_of_birth
	FROM actors
	WHERE first_name = 'Douglas' AND last_name = 'Silva' -- 1988-09-27
)
ORDER BY date_of_birth;

-- subquery returns multiple records (IN operator)
-- find all movies where domestic revenues are > 200
SELECT
	movie_name
FROM movies 
WHERE movie_id IN (
	SELECT movie_id
	FROM movies_revenues
	WHERE revenues_domestic > 200
);

-- list all the directors where their movies made more than the total average revenues of all english movies
SELECT
	d.director_id,
	d.first_name AS "director_first_name",
	d.last_name AS "director_last_name",
	SUM(mr.revenues_domestic + mr.revenues_international) AS "total_revenue"
FROM directors d
JOIN movies m 
	ON m.director_id = d.director_id
JOIN movies_revenues mr
	ON m.movie_id = mr.movie_id
WHERE (mr.revenues_domestic + mr.revenues_international) >
( -- total average revenues of all english movies
	SELECT
		AVG(revenues_domestic + revenues_international) AS "total_avg_revenue"
	FROM movies_revenues 
)
AND m.movie_language = 'English'
GROUP BY d.director_id, d.first_name, d.last_name;


-- order entries in UNION without ORDER BY
SELECT *
FROM (
	SELECT
		first_name,
		0 myorder,
		'actors' AS "table"
	FROM actors
	UNION
	SELECT
		first_name,
		1 myorder,
		'directors' AS "table"
	FROM directors
) t
ORDER BY myorder;

-- subquery alias
SELECT *
FROM (
	SELECT *
	FROM movies
) t;

-- select without FROM
SELECT
(
	SELECT MAX(revenues_domestic)
	FROM movies_revenues
),
(
	SELECT MIN(revenues_domestic)
	FROM movies_revenues
);


-- correlated subquery is a subquery that contains a reference to a table in the parent query, postgres evaluates inside to out

-- list movie_name, movie_language, and movie age certification for all movies with an above minimum length of each age certification
SELECT
	movie_name,
	movie_language,
	movie_length,
	age_certification
FROM movies m
WHERE m.movie_length > (
	SELECT
		MIN(movie_length)
	FROM movies m2
	WHERE m2.age_certification = m.age_certification
)
ORDER BY age_certification ASC, movie_length ASC;

-- check
SELECT
	MIN(movie_length)
FROM movies
WHERE age_certification = 'PG'; -- 98

-- list first, last, dob for oldest actors for each gender
SELECT
	first_name,
	last_name,
	date_of_birth
FROM actors a
WHERE date_of_birth = (
	SELECT
		MIN(date_of_birth) 
	FROM actors a2
	WHERE a.gender = a2.gender
	GROUP BY gender
);


-- IN with subquery
-- find countires that are same countries as customers
SELECT * FROM customers;
SELECT * FROM suppliers;

SELECT *
FROM suppliers s
WHERE country IN (
	SELECT 
		COUNTRY
	FROM customers 
);

-- subquery with ANY, like IN but can use operators other than =
-- find customers details where they ordered more than 20 items in a single product

SELECT c.*
FROM customers c
WHERE c.customer_id = ANY -- can use ALL (all have to match)
	(
		SELECT customer_id
		FROM orders o
		JOIN order_details od ON o.order_id = od.order_id
		WHERE quantity > 20
	);
	
-- EXISTS
-- column list that exists in select of outer query should exist in subquery

-- find suppliers with products that cost less than $100
SELECT
*
FROM suppliers
WHERE EXISTS ( -- row returned from subquery has a supplier_id that exists in suppliers
	SELECT *
	FROM products
	WHERE unit_price < 100
	AND products.supplier_id = suppliers.supplier_id
);