CREATE SCHEMA humanresources;

ALTER SCHEMA sales
RENAME TO apples;

SELECT * FROM hr.public.employees;

ALTER TABLE
	humanresources.orders
SET SCHEMA PUBLIC;

SELECT current_schema();

SHOW search_path;

SET search_path TO '$user',public,humanresources;

ALTER SCHEMA humanresources
OWNER to adam;

-- duplicate schema with all data
CREATE DATABASE test_schema_db;

CREATE TABLE test_schema_db.public.songs(
	song_id SERIAL PRIMARY KEY,
	song_title VARCHAR(100)
);

INSERT INTO songs (song_title) VALUES
	('Holiday'),
	('Final Countdown');
	
SELECT * FROM songs;

SELECT * FROM information_schema.schemata;

-- privileged access to users, owner of table private is postgres user
GRANT USAGE ON SCHEMA private TO adam;
GRANT SELECT ON ALL TABLES IN SCHEMA private TO adam;

GRANT CREATE ON SCHEMA private TO adam;

