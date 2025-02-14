CREATE SEQUENCE IF NOT EXISTS test_seq;

SELECT NEXTVAL('test_seq');

SELECT currval('test_seq');

SELECT setval('test_seq', 100);

CREATE SEQUENCE IF NOT EXISTS test_seq2 START WITH 100;

SELECT NEXTVAL('test_seq2');
SELECT currval('test_seq2');

ALTER SEQUENCE test_seq RESTART WITH 5;

CREATE SEQUENCE test_seq3
START WITH 100
INCREMENT 5;

SELECT nextval('test_seq3');

CREATE SEQUENCE seq_desc
INCREMENT -1
START WITH 10
MINVALUE 0
MAXVALUE 10
CYCLE;

SELECT nextval('seq_desc');

DROP SEQUENCE seq_desc;

-- attach sequence to table column
CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	user_name VARCHAR(50)
);

INSERT INTO users (user_name) VALUES ('Jack');

SELECT * FROM users;

ALTER SEQUENCE users_user_id_seq
RESTART WITH 100;

CREATE TABLE users2 (
	user2_id INT PRIMARY KEY,
	user2_name VARCHAR(50)
);

CREATE SEQUENCE user2_user2_id_seq
START WITH 100
OWNED BY users2.user2_id;

ALTER TABLE users2
ALTER COLUMN user2_id
SET DEFAULT nextval('user2_user2_id_seq');

SELECT * FROM users2;

INSERT INTO users2 (user2_name) VALUES ('Josh');

SELECT relname sequence_name
FROM pg_class
WHERE
relkind = 'S';

CREATE SEQUENCE common_fruits_seq START WITH 100;

CREATE TABLE apples (
	fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
	fruit_name VARCHAR(50) NOT NULL
);

CREATE TABLE mangos (
	fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
	fruit_name VARCHAR(50) NOT NULL
);

CREATE TABLE contacts (
	contact_id SERIAL PRIMARY KEY,
	contact_name VARCHAR(150)
);

DROP TABLE contacts;

CREATE SEQUENCE table_sequence;

CREATE TABLE contacts (
	contact_id TEXT NOT NULL DEFAULT ('ID' || nextval('table_sequence') ),
	contact_name VARCHAR(150)
);

ALTER SEQUENCE table_sequence OWNED BY contacts.contact_id;

INSERT INTO contacts (contact_name) VALUES ('Josh');

SELECT * FROM contacts;