-- CTE is a temporary result taken from sql
-- temporary tables, alternative to subqueries, can be referenced multiple times in sql statement
-- improve readability and interpretability of code

WITH num AS (
	SELECT *
	FROM GENERATE_SERIES(1, 10) AS id
)
SELECT *
FROM num;

WITH cte_director_1 AS (
	SELECT *
	FROM movies m
	JOIN directors d ON m.director_id = d.director_id
	WHERE m.director_id = 1
)
SELECT
	*
FROM cte_director_1;

WITH cte_long_movies AS (
	SELECT
		movie_name,
		movie_length,
		(CASE 
			WHEN movie_length < 100 THEN 'short'
			WHEN movie_length < 120 THEN 'medium'
			WHEN movie_length >= 120 THEN 'long'
		END) AS "length_classification"
	FROM movies
)
SELECT
	*
FROM cte_long_movies
ORDER BY length_classification;

-- total revenues for each director
WITH cte_movie_count AS (
	SELECT
		d.director_id,
		SUM(mr.revenues_domestic) AS "total_revenue"
	FROM directors d
	JOIN movies m ON d.director_id = m.movie_id
	JOIN movies_revenues mr ON m.movie_id = mr.movie_id
	GROUP BY d.director_id
)
SELECT 
	d.first_name,
	d.last_name,
	c.total_revenue
FROM cte_movie_count c
JOIN directors d ON d.director_id = c.director_id
WHERE total_revenue > 20
ORDER BY total_revenue DESC;

-- article table and articles_deleted table
CREATE TABLE articles(
	article_id SERIAL PRIMARY KEY,
	title VARCHAR(100)
);

CREATE TABLE articles_deleted AS SELECT * FROM articles LIMIT 0;

INSERT INTO ARTICLES (title) VALUES
('art1'),
('art2'),
('art3'),
('art4'),
('art5');

SELECT * FROM articles;
SELECT * FROM articles_deleted;

-- simulataneous delete insert
WITH cte_delete_articles AS (
	DELETE FROM articles
	WHERE article_id = '1'
	RETURNING *
)
INSERT INTO articles_deleted
SELECT * FROM cte_delete_articles;

CREATE TABLE articles_insert AS SELECT * FROM articles LIMIT 0;

WITH cte_move_articles AS (
	DELETE FROM articles
	RETURNING *
)
INSERT INTO articles_insert
SELECT * FROM cte_move_articles;

SELECT * FROM articles_insert;

-- recursive CTE
-- cte that calls itself until condition is met, used with hierarhical data, looping structure
-- avoid infinite loops
WITH RECURSIVE series (list_num) AS 
(
	-- non recursive statement
	SELECT 10
	
	UNION ALL
	
	-- recursive statement
	-- 10 + 5 in loop until it becomes 50
	SELECT list_num + 5
	FROM series
	WHERE list_num + 5 <= 50
)
SELECT *
FROM series;

-- parent, child relationship (hierarchical data)
CREATE TABLE items(
	pk SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	parent INT
);

INSERT INTO items (pk, name, parent)
VALUES
(1, 'vegetables', 0),
(2, 'fruits', 0),
(3, 'apple', 2),
(4, 'banana', 2);

SELECT * FROM items;

/*
Tree level view
---------------
1, vegetable
1, fruits
2, fruits -> apple
2, fruits -> banana
*/

WITH RECURSIVE cte_tree AS (
	-- non recursive
	-- all parent info
	SELECT 
		name,
		pk,
		1 AS "tree_level"
	FROM items
	WHERE parent = 0
	
	UNION
	
	-- recursive
	-- loop to get all child of each parent
	SELECT
		c.name || ' -> ' || i.name,
		i.pk,
		c.tree_level + 1
	FROM items i
	JOIN cte_tree c ON i.parent = c.pk
)
SELECT 
	tree_level,
	name
FROM cte_tree;