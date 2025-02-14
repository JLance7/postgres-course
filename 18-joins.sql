-- inner join joines columns between two tables on common columns
-- usuallly primary key of first table and foreign key of second table

/*
SELECT *
FROM table a
JOIN table2 b
ON a.key_col = b.foreign_key_col
*/

SELECT
	m.movie_name,
	m.movie_length,
	d.first_name
FROM movies m
INNER JOIN directors d
	ON m.director_id = d.director_id -- exact match
WHERE m.movie_language = 'English';

-- we use USING when joining columns that have the same column name
SELECT
	movies.*,
	directors.*
FROM movies
INNER JOIN directors USING (director_id);
	
-- movie details and revnue details join on movie_id foregin key in movies_revenues table 
-- to primary key movie_id in movies table
SELECT
	mv.movie_name,
	mv.movie_length,
	mr.revenues_domestic
FROM
	movies mv
INNER JOIN movies_revenues mr
	USING (movie_id)
ORDER BY 
	movie_length DESC;
	
SELECT *
FROM movies
INNER JOIN directors USING (director_id)
INNER JOIN movies_revenues USING (movie_id)
WHERE movies.movie_language = 'Japanese';


CREATE TABLE fav_colors (
	fav_color_id SERIAL PRIMARY KEY,
	color VARCHAR(256)
);

CREATE TABLE fav_people (
	fav_people_id SERIAL PRIMARY KEY,
	person_name VARCHAR(256),
	color_id INTEGER,
	CONSTRAINT fav_people_color_id_fkey FOREIGN KEY (color_id) REFERENCES fav_colors (fav_color_id)
);

INSERT INTO fav_colors (color)
VALUES 
	('Red'),
	('Green'),
	('Blue');
	
INSERT INTO fav_people
	(person_name, color_id)
VALUES
	('John', 1),
	('Mike', 2);

SELECT
	p.person_name,
	c.color
FROM fav_people p
INNER JOIN fav_colors c
	ON p.color_id = c.fav_color_id;

-- get movie name, director name for Japanese, English, and Chinese movies
SELECT
	mv.movie_name,
	d.first_name AS "director_name",
	mr.revenues_domestic
FROM movies mv
JOIN directors d USING (director_id)
JOIN movies_revenues mr
	ON mv.movie_id = mr.movie_id
WHERE mv.movie_language IN ('Japanese', 'English', 'Chinese')
	AND mr.revenues_domestic > 100
ORDER BY
	mr.revenues_domestic DESC;

-- most profitable movies between 2005 and 2008
SELECT
	mv.movie_name,
	mv.movie_length,
	d.first_name AS "director_name",
	mr.revenues_domestic,
	(mr.revenues_domestic + mr.revenues_international) AS "total_revenue"
FROM movies mv
JOIN directors d USING (director_id)
JOIN movies_revenues mr USING (movie_id)
WHERE
	mv.release_date BETWEEN '2005-01-01' AND '2008-01-01'
ORDER BY total_revenue DESC 
NULLS LAST
LIMIT 5;

SELECT COUNT(*) FROM movies mv
WHERE
	mv.release_date BETWEEN '2005-01-01' AND '2008-01-01';


CREATE TABLE t1(
	test INT
);

CREATE TABLE t2(
	test VARCHAR(10)
);

SELECT *
FROM t1
JOIN t2 
	ON t1.test::TEXT = t2.test;
	
SELECT *
FROM t1
JOIN t2 
	ON t1.test = CAST(t2.test AS INT);
	
	
-- left joins
-- every row from left table + cols that match from right table
CREATE TABLE left_products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100)
);

CREATE TABLE right_products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(100)
);

INSERT INTO left_products (product_id, product_name)
VALUES
	(1, 'computers'),
	(2, 'laptops'),
	(3, 'monitors');
	
INSERT INTO right_products (product_id, product_name)
VALUES
	(1, 'computers'),
	(2, 'laptops'),
	(4, 'monitors');
	
SELECT *
FROM left_products
LEFT JOIN right_products ON
	left_products.product_id = right_products.product_id;
	
-- all movies for each director
SELECT
	COUNT(movies.movie_name),
	directors.first_name,
	directors.last_name
FROM directors
LEFT JOIN movies ON
	directors.director_id = movies.director_id
GROUP BY 2, 3
ORDER BY 1 DESC;

-- total revenue done by films for each director
SELECT
	d.first_name || ' ' || d.last_name AS "director_name",
	SUM((mr.revenues_domestic + mr.revenues_international)) AS "total_revenue"
FROM
	directors d
LEFT JOIN movies m
	ON m.director_id = d.director_id
LEFT JOIN movies_revenues mr
	ON m.movie_id = mr.movie_id
GROUP BY
	d.first_name, d.last_name
ORDER BY total_revenue DESC
NULLS LAST;


SELECT
	d.first_name || ' ' || d.last_name AS "director_name",
	m.movie_name
FROM
	directors d
LEFT JOIN movies m
	ON m.director_id = d.director_id
WHERE d.first_name = 'Ridley';

SELECT * FROM directors;

CREATE TABLE classes(
	class_id SERIAL PRIMARY KEY,
	class_nm VARCHAR(256)
);

CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY,
	teacher_nm VARCHAR(256)
);

CREATE TABLE classes_to_teachers(
	id SERIAL PRIMARY KEY,
	class_id INT,
	teacher_id INT,
	CONSTRAINT classes_to_teachers_class_id_fkey FOREIGN KEY (class_id) REFERENCES classes (class_id),
	CONSTRAINT classes_to_teachers_teacher_idfkey FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id)
);

ALTER TABLE classes_to_teachers
ADD CONSTRAINT classes_to_teachers_pkey PRIMARY KEY (class_id, teacher_id);

SELECT * FROM classes_to_teachers;

INSERT INTO classes (class_nm)
VALUES
	('Math'),
	('History'),
	('Science');
	
INSERT INTO teachers (teacher_nm)
VALUES
	('John'),
	('Mike'),
	('Alex');
	
INSERT INTO classes_to_teachers
	(class_id, teacher_id)
VALUES
	(1, 1),
	(1, 2),
	(2, 1),
	(3, 1);
	
SELECT
	t.teacher_nm,
	c.class_nm
FROM classes_to_teachers ct
INNER JOIN classes c
	ON ct.class_id = c.class_id
INNER JOIN teachers t
	ON ct.teacher_id = t.teacher_id;


-- right join
-- every row from right table + rows that match from left table
SELECT *
FROM left_products
RIGHT JOIN right_products
	ON left_products.product_id = right_products.product_id;
	
-- count all movies for each director
SELECT
	COUNT(*),
	CONCAT(d.first_name, ' ', d.last_name) AS "director_name"
FROM movies m
RIGHT JOIN directors d
	ON d.director_id = m.director_id
GROUP BY 2
ORDER BY 1 DESC
NULLS LAST;

-- full join returns every row from all tables
SELECT
	*
FROM left_products
FULL join right_products USING (product_id);

-- multiple table joins
SELECT
	COUNT(m.movie_name),
	a.first_name || ' ' || a.last_name AS "actor_name"
FROM actors a
join movies_actors ma 
	ON a.actor_id = ma.actor_id
JOIN movies m
	ON ma.movie_id = m.movie_id
GROUP BY
	2
HAVING COUNT(m.movie_name) > 1;

SELECT
	m.movie_name,
	a.first_name || ' ' || a.last_name AS "actor_name"
FROM actors a
join movies_actors ma 
	ON a.actor_id = ma.actor_id
JOIN movies m
	ON ma.movie_id = m.movie_id
WHERE a.first_name || ' ' || a.last_name = 'Alec Guiness';

-- self join
-- compare rows in the same table
SELECT
	m.movie_name,
	m2.movie_name,
	m.movie_length
FROM movies m
JOIN movies m2 ON	
	m.movie_length = m2.movie_length
AND m.movie_name <> m2.movie_name;

-- heirarical view
SELECT
	m.movie_name,
	m2.director_id
FROM movies m
INNER JOIN movies m2
	ON m.director_id = m2.movie_id
ORDER BY m2.director_id;

-- cross join
-- cartesian product, lines up each row in left table with each row in right table to show all possibilities
-- n rows in table 1 and m rows in table 2 = n * m combinations
SELECT *
FROM left_products
CROSS JOIN right_products;

SELECT *
FROM right_products
CROSS JOIN left_products;

-- natural join is implicit join based on same column names
-- can be left, right, or inner, inner used by default
SELECT *
FROM left_products
NATURAL JOIN right_products;

SELECT *
FROM left_products
NATURAL LEFT JOIN right_products;

CREATE TABLE table2(
	add_date DATE,
	col1 INT,
	col2 INT,
	col3 INT,
	col4 INT,
	col5 INT
);

SELECT * FROM table1;
SELECT * FROM table2;

INSERT INTO table1 (add_date, col1, col2, col3)
VALUES
	('2020-01-01', 1, 2, 3),
	('2020-01-02', 4, 5, 6);
	
INSERT INTO table2 (add_date, col1, col2, col3, col4, col5)
VALUES
	('2020-01-01', NULL, 7, 8, 9, 10),
	('2020-01-02', 11, 12, 13, 14, 15),
	('2020-01-03', 16, 17, 18, 19, 20);
	
-- result wanted (1, 2, 3 from table1 and 4, 5 from table2)
SELECT
	COALESCE(t1.add_date, t2.add_date),
	COALESCE(t1.col1, t2.col1),
	COALESCE(t1.col2, t2.col2),
	COALESCE(t1.col3, t2.col3),
	t2.col4,
	t2.col5
FROM table1 t1
FULL OUTER JOIN table2 t2
	ON (t1.add_date = t2.add_date);