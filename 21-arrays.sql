SELECT
	INT4RANGE(1,6),
	NUMRANGE(1.2, 6.2, '[]'),
	DATERANGE('2020-01-01', '2025-01-01', '()'),
	TSRANGE(LOCALTIMESTAMP, LOCALTIMESTAMP + INTERVAL '8 days', '(]');
	
SELECT
	ARRAY[1, 2, 3],
	ARRAY[CURRENT_DATE, CURRENT_DATE + 5];
	
SELECT
	INT4RANGE(1, 4),
	INT4RANGE(2, 3),
	INT4RANGE(1, 4) @> INT4RANGE(2, 3) AS "contains",
	DATERANGE(CURRENT_DATE, CURRENT_DATE + 30) @> CURRENT_DATE + 15 as "contains value",
	NUMRANGE(1.6, 5.2) && NUMRANGE(0, 4);
	
SELECT
	ARRAY[1, 2, 3, 4] @> ARRAY[2, 3, 4] AS "contains",
	ARRAY['a', 'b'] <@ ARRAY['a', 'b'] AS "contains value",
	ARRAY[2, 3, 4] && ARRAY[1, 2, 3, 4] AS "is overlap";
	
SELECT
	ARRAY[1, 2, 3, 4] || ARRAY[5, 6, 7, 8] || 9 AS "Combine arrays",
	ARRAY_CAT(ARRAY[1, 2, 3, 4], ARRAY[5, 6, 7, 8]) AS "Combine arrays cat";
-- ARRAY_PREPEND() and ARRAY_APPEND()

SELECT
	ARRAY_NDIMS(ARRAY[[1],[2]]) AS "dimensions"
	
SELECT
	ARRAY_NDIMS(ARRAY[[1,2,3],[4,5,6]]);
	
SELECT
	ARRAY_DIMS(ARRAY[[1], [2]]);
	
SELECT
	ARRAY_LENGTH(ARRAY[1,2,3,4], 1);
	
SELECT	
	ARRAY_LOWER(ARRAY[2, 2, 2, 2], 1),
	ARRAY_UPPER(ARRAY[3, 3, 3, 3], 1); -- like length of the array

-- cardinality, array dimension or total # of elements in array
SELECT
	CARDINALITY(ARRAY[[1],[2]]),
	CARDINALITY(ARRAY[1, 2]);
	
SELECT
	ARRAY_POSITION(ARRAY['Jan', 'Feb', 'March'], 'Feb');
	
SELECT
	ARRAY_POSITIONS(ARRAY[1, 2, 2, 4], 2),
	ARRAY_REMOVE(ARRAY[1, 2, 3, 4], 1),
	ARRAY_REPLACE(ARRAY[1, 2, 4, 5], 2, 10);

SELECT
	20 IN (1, 2, 20, 40);
	
SELECT
	25 = ALL(ARRAY[25, 24]),
	25 = ALL(ARRAY[25, 25]);
	
SELECT
	STRING_TO_ARRAY('1,2,3,4', ','),
	STRING_TO_ARRAY('1,2,3,4,5,6', ',', '5'),
	ARRAY_TO_STRING(ARRAY[1,2,3,4], '|');
	
CREATE TABLE teachers1 (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	phones TEXT[] -- can also use TEXT ARRAY
);
	
INSERT INTO teachers1 (name, phones)
VALUES
	('Adam', ARRAY['222-222-2222', '333-333-3333']);

SELECT * FROM teachers1;

INSERT INTO teachers1 (name, phones)
VALUES
	('Linda', '{"111-111-1111", "222-222-2222"}')
	
SELECT
	name,
	phones[1]
FROM teachers1;

SELECT *
FROM teachers1
WHERE '111-111-1111' = ANY(phones);

SELECT
	name,
	UNNEST(phones)
FROM teachers1;

CREATE TABLE students1(
	student_id SERIAL PRIMARY KEY,
	student_name VARCHAR(100),
	student_grade INTEGER[][]
);

INSERT INTO students1 (student_name, student_grade)
VALUES
	('s1', '{90, 2020}')
	
SELECT * FROM students1;

INSERT INTO students1 (student_name, student_grade)
VALUES
	('s2', '{70, 2019}'),
	('s3', '{80, 2020}');
	
SELECT student_grade[1], student_grade[2]
FROM students1;

SELECT * FROM students1;

-- all students with grade year 2020
SELECT * FROM students1 WHERE student_grade @> '{2020}';
SELECT * FROM students1 WHERE 2020 = ANY(student_grade);

-- all students with grade > 80
SELECT * FROM students1 WHERE student_grade[1] > 80;

-- JOSNB type is faster at reading but slower at writing than JSON
-- ARRAY is faster than JSONB but is sequential only