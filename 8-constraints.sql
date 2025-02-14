CREATE TABLE persons (
	person_id SERIAL PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL
);

-- add column
ALTER TABLE persons
ADD COLUMN age INT NOT NULL;

SELECT * FROM persons;

ALTER TABLE persons
ADD COLUMN nationality VARCHAR(20) NOT NULL;

ALTER TABLE persons
ADD COLUMN email VARCHAR(100) UNIQUE;

-- rename table
ALTER TABLE users
RENAME TO persons;

-- rename column
ALTER TABLE persons
RENAME COLUMN age TO person_age;

-- drop column
ALTER TABLE persons
DROP COLUMN person_age;

ALTER TABLE persons
ADD COLUMN age VARCHAR(10);

-- change data type of column
ALTER TABLE persons
ALTER COLUMN age TYPE INT
USING age::integer;

ALTER TABLE persons
ALTER COLUMN age TYPE VARCHAR(20);

SELECT * FROM persons;

-- set default value of column
ALTER TABLE persons
ADD COLUMN is_enable VARCHAR(1);

ALTER TABLE persons
ALTER COLUMN is_enable SET DEFAULT 'Y';

INSERT INTO persons (
	first_name,
	last_name,
	nationality,
	age
)
VALUES
	('John', 'Smith', 'US', 40);
	
-- constraints to columns
CREATE TABLE web_links (
	link_id SERIAL PRIMARY KEY,
	link_url VARCHAR(255) NOT NULL,
	link_target VARCHAR(20)
);

SELECT * FROM web_links;

INSERT INTO web_links (link_url, link_target)
VALUES 
	('https://www.google.com', '_blank');
	
ALTER TABLE web_links
ADD CONSTRAINT unique_web_url UNIQUE (link_url);

ALTER TABLE web_links
ADD COLUMN is_enable VARCHAR(2);

INSERT INTO web_links (link_url, link_target, is_enable) VALUES ('https://www.amazon.com', '_blank', 'Yo');

ALTER TABLE web_links
ADD CHECK (is_enable IN ('Y', 'N'));

UPDATE web_links
SET is_enable = 'Y'
WHERE is_enable IS NULL;