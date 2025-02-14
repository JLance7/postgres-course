-- string functions
SELECT UPPER('amazing text');

SELECT LOWER('Amazing Text');

SELECT INITCAP('the world is ending');

SELECT
	INITCAP(
		CONCAT(first_name, ' ', last_name)
	) AS full_name
FROM directors
ORDER BY first_name;

SELECT LEFT('awesome', 3);

SELECT LEFT('abc', -2);

SELECT
	LEFT(first_name, 1) AS initial,
	COUNT(*) AS total_initials
FROM directors
GROUP BY 1
ORDER BY 1;

SELECT
	movie_name,
	LEFT(movie_name, 6)
FROM movies;

SELECT RIGHT('ABCD', -1);

SELECT
	last_name,
	RIGHT(last_name, 2)
FROM directors
WHERE RIGHT(last_name, 2) = 'on';

SELECT REVERSE('wowzers');

SELECT SPLIT_PART('1, 2, 3', ', ', 2);

SELECT SPLIT_PART('A|B|C|D', '|', 3);

SELECT
	movie_name,
	release_date,
	SPLIT_PART(release_date::TEXT, '-', 1) AS release_year
FROM movies;


SELECT
	TRIM(
		LEADING
		FROM '   Amazing postgres'
	),
	TRIM(
		TRAILING
		FROM 'Amazing postgres  '
	),
	TRIM('  Amazing postgres   ');
	
SELECT
	TRIM(
		LEADING '0'
		FROM CAST(012423 AS TEXT)
	);
	
SELECT
	LTRIM('yummy', 'y');
	
SELECT RTRIM('yummy', 'y');

SELECT BTRIM('yummy', 'y');

SELECT LTRIM('   amazing postgres');

SELECT RTRIM('amazing postgres.  ');

SELECT BTRIM('   amazing postgres.  ');


SELECT LPAD('amazing', 10, '-');

SELECT LPAD('nice', 15, '*');

SELECT RPAD('this is a long string', 12, '...');

SELECT
	mv.movie_name,
	r.revenues_domestic,
	LPAD( '*', CAST(TRUNC(r.revenues_domestic / 10) AS INT), '*' ) AS chart
FROM movies mv
INNER JOIN movies_revenues r ON r.movie_id = mv.movie_id
ORDER BY 3 DESC
NULLS LAST;

SELECT LENGTH('howdy partner!');
SELECT LENGTH('abcdefghijklmnopqrstuvwxyz');

SELECT POSITION('Grace' IN 'Amazing Grace');

SELECT STRPOS('World Bank', 'Bank');

SELECT
	first_name,
	last_name
FROM directors
WHERE STRPOS(last_name, 'on') > 0;

SELECT SUBSTRING('What a wonderful world' FROM 1 FOR 4);

SELECT
	first_name,
	last_name,
	SUBSTRING(first_name, 1, 1) || SUBSTRING(last_name, 1, 1) AS initial
FROM directors
ORDER BY 
	last_name;
	
SELECT REPEAT('A', 400);

SELECT REPLACE('I like cats', 'cats', 'dogs');






