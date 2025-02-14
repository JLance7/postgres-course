-- DISTINCT ON gets first result returned by ORDER BY clause
SELECT region, country, year
FROM trades
ORDER BY year DESC, region;

SELECT 
	DISTINCT ON(year) * -- returns record, one per year
FROM trades
ORDER BY year DESC, region ASC;


-- A window function does aggregation without flattening into a single row
-- performs a set of operations across a set of table rows that are somehow releated to the current row

CREATE TABLE trades(
	region TEXT,
	country TEXT,
	year INT,
	imports NUMERIC(50, 0),
	exports NUMERIC(50, 0)
);

SELECT * FROM trades;

SELECT MIN(year), MAX(year) FROM trades;

SELECT DISTINCT(region) FROM trades;

-- avg imports by region
SELECT
	region,
	country,
	ROUND(AVG(imports) / 1000000000, 2) AS "avg"
FROM trades
WHERE country IN ('Argentina', 'Brazil', 'Singapore')
GROUP BY
	ROLLUP (region, country)
ORDER BY 2;
	

-- CUBE (all possible grouping sets based on dimension of columns specified in CUBE)
SELECT
	region,
	country,
	ROUND(AVG(imports) / 1000000000, 2) AS "avg"
FROM trades
WHERE country IN ('Argentina', 'Brazil', 'Singapore')
GROUP BY
	CUBE(region, country)
ORDER BY 2;

-- GROUPING SET (set of columns by which you group by using GROUP BY clause)
SELECT
	region,
	country,
	ROUND(AVG(imports) / 1000000000, 2) AS "avg"
FROM trades
WHERE country IN ('Argentina', 'Brazil', 'Singapore')
GROUP BY
	GROUPING SETS (
		(),
		region,
		country
	);
	
-- FILTER allows you to selectively pass data to aggregates
SELECT
	region,
	AVG(exports) AS avg_all,
	AVG(exports) FILTER (WHERE year < 1995) AS avg_over_1995 -- filters and then passes to AVG
FROM trades
GROUP BY
	ROLLUP(region);

-- Window functions
-- aggregates take many rows and turn them into fewer (flatten the data), 
-- window functions compares current row with all rows in group 
SELECT AVG(imports) FROM trades;

SELECT country, year, imports, exports, AVG(exports) 
FROM trades
GROUP BY
	country, year, imports, exports
ORDER BY country;

SELECT country, year, imports, exports, AVG(exports) OVER() AS avg_exports -- also shows average exports of a ll data
FROM trades
ORDER BY country;

-- partitioning data (average of the country)
-- shows row data and also the average exports by country
SELECT country, year, imports, exports, AVG(exports) OVER(PARTITION BY country) AS avg_exports 
FROM trades
ORDER BY country;

-- filter by in partition, average exports for entire dataset where year is < 2000, along with row's data
SELECT country, year, imports, exports, AVG(exports) OVER(PARTITION BY year < 2000) AS avg_exports 
FROM trades
ORDER BY year;

SELECT
	imports,
	ROUND(imports/1000000, 2)
FROM trades;

UPDATE trades
SET imports = ROUND(imports/1000000, 2), exports = ROUND(exports/1000000, 2);

SELECT * FROM trades;

-- ordering inside window
-- max exports for some specific countries for period 2001 onwards
SELECT
	country,
	year,
	exports,
	MIN(exports) OVER(PARTITION BY country ORDER BY year) AS "min_exports_per_country"
FROM trades
WHERE
	year > 2001
	AND country IN ('USA', 'France');