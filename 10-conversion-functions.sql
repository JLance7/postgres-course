-- to_char converts datatype to text with options
SELECT
	TO_CHAR(
		100870,
		'9,99999'
	);
	
SELECT
	release_date,
	TO_CHAR(release_date, 'DD-MM-YYY'),
	TO_CHAR(release_date, 'Dy, MM, YYYY')
FROM movies;

SELECT
	TO_CHAR(
		TIMESTAMP '2020-01-02 10:30:45',
		'HH24:MI:SS'
	);
	
SELECT
	movie_id,
	revenues_domestic,
	TO_CHAR(
		revenues_domestic,
		'$999999999'
	)
FROM movies_revenues;

SELECT
	TO_NUMBER(
		'105.7',
		'999.99'
	);
	
SELECT
	TO_NUMBER(
		'10,625.78-',
		'99G999.9999S'
	);
	
SELECT
	TO_NUMBER(
		'1,234,567',
		'9G999G999'
	);


SELECT
	TO_DATE(
		'2020/10/22',
		'YYYY/MM/DD'
	);
	
SELECT
	TO_TIMESTAMP(
		'2020-10-28 10:30:25',
		'YYYY-MM-DD HH:MI:SS'
	);