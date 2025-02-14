-- JSONB supports full text searching, JSON does not
SELECT '{
	"title": "Lord of the Rings",
	"author": "J.R.R"
	}'::JSONB;

CREATE TABLE books(
	book_id SERIAL PRIMARY KEY,
	book_info JSONB
);

INSERT INTO books (book_info)
VALUES
	('{
	 "title": "Book title 1", 
	 "author": "author 1"
	 }');

INSERT INTO books (book_info)
VALUES
	('{
	 "title": "Book title 2", 
	 "author": "author 2"
	 }'),
	 ('{
	 "title": "Book title 3", 
	 "author": "author 3"
	 }'),
	 ('{
	 "title": "Book title 4", 
	 "author": "author4"
	 }');
SELECT * FROM books;

/*
-> returns field in double quotes
->> returns field as text
*/

SELECT
	book_info->'title',
	book_info->>'title' AS "title",
	book_info->>'author' AS "author"
FROM books;

INSERT INTO books (book_info)
VALUES
	('{"title": "Eragon", "author": "Ronald Weasley"}');
	
UPDATE books
SET book_info = book_info || '{"title": "Inheritance", "category": "English"}' -- adds or replaces field (concat operator)
WHERE book_info->>'author' = 'Ronald Weasley'
RETURNING *;

UPDATE books
SET book_info = book_info || '{"availability_locations": [
	"New Jersey",
	"Missouri"
]}'
WHERE book_info->>'author' = 'Ronald Weasley'
RETURNING *;

-- delete second value in json array
UPDATE books
SET book_info = book_info #- '{availability_locations, 1}'
WHERE book_info->>'author' = 'Ronald Weasley'
RETURNING *;

-- convert table into json
SELECT ROW_TO_JSON(directors) FROM directors;

SELECT ROW_TO_JSON(t) FROM
(
	SELECT
		first_name,
		last_name,
		nationality
	FROM directors
) AS t;

SELECT 
	*,
	(
		SELECT
			JSON_AGG(x) AS "all_movies_json" 
			FROM (
				SELECT
					movie_name
				FROM movies
				WHERE director_id = directors.director_id
			) AS x
	)
FROM directors;

SELECT
	JSON_BUILD_ARRAY(1, 2, 3, 4, 5, 'hi'),
	JSON_BUILD_OBJECT(1, 2, 3, 4, 5, 'hi'),
	JSON_OBJECT('{name, email}', '{"Josh", "josh@gmail.com"}');
	
CREATE TABLE directors_docs (
	director_id SERIAL PRIMARY KEY,
	body JSONB
);

-- get all movies by each director in JSON array format
INSERT INTO directors_docs (body) 
SELECT ROW_TO_JSON(a)::JSONB FROM
(
	SELECT
		director_id,
		first_name,
		last_name,
		date_of_birth,
		nationality,
		(
			SELECT JSON_AGG(x) AS "movies_json" FROM
			(
				SELECT
					movie_name
				FROM movies
				WHERE movies.director_id = directors.director_id
			) x
		) 
	FROM directors
) a;

SELECT * FROM directors_docs;

SELECT
	JSONB_ARRAY_ELEMENTS(body->'movies_json') FROM directors_docs
WHERE (body->'movies_json') IS NOT NULL;
-- deal with null values
INSERT INTO directors_docs (body) 
SELECT ROW_TO_JSON(a)::JSONB FROM
(
	SELECT
		director_id,
		first_name,
		last_name,
		date_of_birth,
		nationality,
		(
			SELECT CASE COUNT(x) WHEN 0 THEN '[]' ELSE JSON_AGG(x) END AS "movies_json" FROM
			(
				SELECT
					movie_name
				FROM movies
				WHERE movies.director_id = directors.director_id
			) x
		) 
	FROM directors
) a;

-- total movies for each director
SELECT
	*,
	JSONB_ARRAY_LENGTH(body->'movies_json') AS "total_movies"
FROM directors_docs;

SELECT
	*,
	JSONB_OBJECT_KEYS(body)
FROM directors_docs; -- showing keys for each json document row

-- keys and values for each row
SELECT
	j.key,
	j.value
FROM directors_docs, JSONB_EACH(directors_docs.body) j;

-- JSON doc to table format
SELECT
	j.*
FROM directors_docs, JSONB_TO_RECORD(directors_docs.body) j (
	director_id INT,
	first_name VARCHAR(255)
);

-- find all first_name equal to John
SELECT
	*
FROM directors_docs
WHERE body->'first_name' ? 'John';

-- ? expect both left and right values to be text (like = comparison)

-- containment operator @>
SELECT
	*
FROM directors_docs
WHERE body @> '{"first_name": "John"}';

-- records with director_id 1
SELECT
	*
FROM directors_docs
WHERE body @> '{"director_id": 1}';

SELECT
	*
FROM directors_docs
WHERE body->'movies_json' @> '[{"movie_name": "Toy Story"}]';

-- all records where first_name starts with J
SELECT
	*
FROM directors_docs
WHERE body->>'first_name' LIKE 'J%';

EXPLAIN SELECT
	*
FROM directors_docs
WHERE body->>'first_name' LIKE 'J%';

-- director_id > 2
SELECT
	*
FROM directors_docs
WHERE (body->>'director_id')::INTEGER > 2;

SELECT COUNT(*) FROM contacts_docs;

-- indexing json
SELECT * FROM contacts_docs;

EXPLAIN ANALYZE SELECT *
FROM contacts_docs
WHERE body @> '{"first_name": "John"}';

-- GIN index speeds up full text searches
CREATE INDEX idx_gin_contacts_docs_body ON contacts_docs USING GIN(body JSONB_PATH_OPS);

SELECT pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body'::regclass)) AS index_size;

 

SELECT
	*
FROM directors_docs
WHERE (body->>'director_id')::INTEGER IN (1, 2, 3, 4, 5);