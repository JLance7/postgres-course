SELECT CAST('Josh' AS character(10));

SELECT 'Josh'::character(10);

CREATE TABLE test_types (
	first CHAR(10),
	second VARCHAR(10),
	third TEXT
);

SELECT * FROM test_types;

/*
date - date only
time - time only
timestamp - date and time
timestamptz- date, time, and timezone
interval- stores values	
*/

/*
Date YYYY-MM-DD
Userful keywords:
	CURRENT_DATE for today's date
	NOW() for today's date and time
*/
CREATE TABLE dates (
	id SERIAL PRIMARY KEY,
	employee_name VARCHAR(100) NOT NULL,
	hire_date DATE NOT NULL,
	add_date DATE DEFAULT CURRENT_DATE	
);

SELECT employee_name FROM dates;

INSERT INTO dates (employee_name, hire_date) VALUES ('Adam', '2020-01-01'),
('Josh', '2019-02-20');

SELECT * FROM dates;
SELECT NOW();

/*
TIME stores time of day

HH:MM
HH:MM:SS
HH:MM:SS.pppp
HHMMSS
*/

CREATE TABLE table_time (
	id serial primary key,
	class_name varchar(100) not null,
	state_time TIME NOT NULL,
	end_time TIME NOT NULL
);

INSERT INTO table_time (class_name, start_time, end_time)
VALUES
	('MATH', '08:00:00', '09:00:00'),
	('CHEM', '09:01:00', '10:00:00');
	
SELECT * FROM table_time;
SELECT CURRENT_TIME;
SELECT CURRENT_TIME(2);

SELECT LOCALTIME;

-- arithematic
SELECT TIME '10:00' - TIME '04:00';

SELECT CURRENT_TIME + INTERVAL '2 hours' AS result;

/*
TIMESTAMP is date & time together
timestamptz has timezone too (always in UTC, same as GMT, 5 hours ahead of CST), and input with timezone
	specified is converted to UTC time, if not timezone is specified it is assumed to use systems tz and 
	is converted to UTC also.
	
	Output from timestamptz is always converted from UTC to current time zone and displayed as local time

*/

CREATE TABLE time_tz (
	ts TIMESTAMP,
	tstz TIMESTAMPTZ
);

INSERT INTO time_tz (ts, tstz) VALUES 
	('2020-02-02 10:10-07', '2020-02-02 10:10-07');
	
SELECT * FROM time_tz;

SHOW TIMEZONE;
SET TIMEZONE = 'America/Chicago';

SELECT CURRENT_TIMESTAMP;
SELECT TIMEOFDAY();

-- convert time based on timezone
SELECT TIMEZONE('Asia/Singapore', '2020-01-01 00:00:00');

/*
UIUID - universal unique identifier
each id is unique, much better than serial for uniqueness
*/
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT uuid_generate_v1();

CREATE TABLE table_uuid (
	product_id UUID DEFAULT uuid_generate_v1(),
	product_name VARCHAR(100) NOT NULL
);

SELECT * FROM table_uuid;
INSERT INTO table_uuid (product_name) VALUES ('ABC');

/*
Every data type has array companion
integer[]
*/

CREATE TABLE table_array (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	phones TEXT[]
);
SELECT * FROM table_array;

INSERT INTO table_array (name, phones) VALUES
	('John', ARRAY['123', '456', '789']);
	
INSERT INTO table_array (name, phones) VALUES
	('Mike', ARRAY['1', '2', '5']);
	
SELECT name, phones[1] FROM table_array;
SELECT name FROM table_array WHERE phones[3] LIKE '5%';

/*
hstore stores data in key value pairs
stores strings
*/
CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE table_hstore (
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	book_info hstore
);

SELECT * FROM table_hstore;
INSERT INTO table_hstore (title, book_info) VALUES
	('title 1', 
	 '
	 	"publisher" => "ABC publisher",
	 	"paper_cost" => "10.00",
	 	"e_cost" => "5.85"
	 ');
INSERT INTO table_hstore (title, book_info) VALUES
	('title 2', 
	 '
	 	"publisher" => "123 publisher",
	 	"paper_cost" => "20.00",
	 	"e_cost" => "6.85"
	 ');
	 
SELECT 
	book_info -> 'publisher' AS "publisher"
FROM table_hstore;

/*
JSON
JSONB binary version
*/
CREATE TABLE IF NOT EXISTS table_json (
	id SERIAL PRIMARY KEY,
	docs JSON
);
SELECT * FROM table_json;

INSERT INTO table_JSON (docs) VALUES
	('[1, 2, 3, 4, 5, 6]'),
	('[2, 3, 4, 5, 6, 7]'),
	('{"key": "value"}');
	
SELECT * FROM table_json
WHERE docs @> '2'; -- operator needs jsonb

ALTER TABLE table_json
ALTER COLUMN docs TYPE JSONB;

CREATE INDEX ON table_json USING GIN (docs jsonb_ops);

/*
network addresses
cidr
inet
macaddr
macaddr8

*/

CREATE TABLE table_netaddr (
	id SERIAL PRIMARY KEY,
	ip INET
);

INSERT INTO table_netaddr (ip) VALUES
	('4.35.221.243');
SELECT * FROM table_netaddr;
set_masklen(ip, 24)