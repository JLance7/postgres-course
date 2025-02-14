-- Data type conversion from one type to another
SELECT * FROM movies
WHERE movie_id = 1;

SELECT * FROM movies
WHERE movie_id = INTEGER '1';

-- character (char, varchar, text)
-- Numeric (integer, floating point number)

SELECT CAST('10' AS INTEGER);
SELECT CAST('2024-11-4' AS DATE);

SELECT CAST('true' AS BOOLEAN);

SELECT CAST('14.788' AS DOUBLE PRECISION);

SELECT '10'::INTEGER;

SELECT '2024-11-4 10:52:00'::TIMESTAMPTZ;

SELECT '10 minute'::INTERVAL;

SELECT CAST(20 AS BIGINIT) ! AS "result";

SELECT ROUND(10, 4) AS "result";

SELECT ROUND(CAST(10 AS NUMERIC), 4) AS "result";

SELECT SUBSTR('12345', 2);