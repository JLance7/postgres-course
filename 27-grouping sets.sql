-- summarization with grouping sets, set of columns by which you group
CREATE TABLE courses (
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(100) NOT NULL,
	course_level VARCHAR(100) NOT NULL,
	sold_units INT NOT NULL
);

SELECT *
FROM courses;

INSERT INTO courses (course_name, course_level, sold_units)
VALUES
('ML', 'Premium', 100),
('DS', 'Premium', 50),
('Intro to python', 'Basic', 200),
('Understanding mongodb', 'Premium', 100),
('Algos in python', 'Premium', 200);

SELECT *
FROM courses
ORDER BY course_level, sold_units;

-- total units sold by each course level
SELECT
	course_level,
	SUM(sold_units)
FROM courses
GROUP BY course_level;

-- with ROLLUP to create group sets for basic and premium
SELECT
	course_name,
	course_level,
	SUM(sold_units) AS "total_sold"
FROM courses
GROUP BY
	ROLLUP(course_level, course_name)
ORDER BY
	course_level,
	course_name;
	
-- subtotal with ROLLUP
CREATE TABLE inventory (
	inventory_id SERIAL PRIMARY KEY,
	category VARCHAR(100) NOT NULL,
	sub_category VARCHAR(100) NOT NULL,
	product VARCHAR(100) NOT NULL,
	quantity INT
);

INSERT INTO inventory (category, sub_category, product, quantity)
VALUES
('Furniture', 'Chair', 'Black', 10),
('Furniture', 'Table', 'Brown', 10),
('Furniture', 'Desk', 'Blue', 10),
('Equipment', 'Computer', 'Mac', 5),
('Equipment', 'Computer', 'PC', 5),
('Equipment', 'Montiro', 'Dell', 10);
--TRUNCATE inventory;
SELECT * FROM inventory;

-- group data by category and subcategory
SELECT
	category,
	sub_category,
	SUM(quantity) AS "quantity_sum"
FROM inventory
GROUP BY
	category,
	sub_category;
	
-- we want a subtotal of each category and final total
SELECT
	category,
	SUM(quantity) AS "quantity_sum"
FROM inventory
GROUP BY
	ROLLUP(category);
	
SELECT
	category,
	sub_category,
	SUM(quantity) AS "quantity_sum"
FROM inventory
GROUP BY
	ROLLUP(category, sub_category)
ORDER BY
	category, sub_category;
	

-- GROUPING is a special aggregate function in conjunction with ROLLUP, returns 0 or 1
-- returns 0 if it is not a subtotal row for a given column
SELECT
	COALESCE(category, ''),
	COALESCE(sub_category, ''),
	SUM(quantity) AS "quantity_sum",
	CASE 
		WHEN GROUPING(category) = 1 AND GROUPING(sub_category) = 1 THEN 'Grand total'
		WHEN GROUPING(category) = 1 THEN 'Category total'
		WHEN GROUPING(sub_category) = 1 THEN 'Subcategory total'
		ELSE ''
	END AS "total/subtotal"
	--GROUPING(category) AS "category_grouping",
	--GROUPING(sub_category) AS "sub_category_grouping"
FROM inventory
GROUP BY
	ROLLUP(category, sub_category)
ORDER BY
	category, sub_category;
