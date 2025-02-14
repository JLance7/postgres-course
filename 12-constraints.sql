-- constraints prevent invalid data from being entered into the database
-- ensures accuracy and reliability of data
CREATE TABLE table_nn (
	id SERIAL PRIMARY KEY,
	tag TEXT NOT NULL
);

INSERT INTO table_nn (tag) VALUES ('1'), ('2');

SELECT * FROM table_nn;

ALTER TABLE table_nn
ALTER COLUMN tag SET NOT NULL;

CREATE TABLE table_emails (
	id SERIAL PRIMARY KEY,
	email TEXT UNIQUE
);

INSERT INTO table_emails
	(email)
VALUES
	('josh@gmail.com'),
	('josh2@gmail.com');
	
SELECT * FROM table_emails;

CREATE TABLE table_products (
	id SERIAL PRIMARY KEY,
	product_code VARCHAR(10),
	product_name TEXT
);

ALTER TABLE table_products
ADD CONSTRAINT unique_constraint UNIQUE (product_code);

is_enable BOOLEAN DEFAULT true;

ALTER TABLE table_products
ALTER COLUMN product_name SET DEFAULT 'cool_product';

ALTER TABLE table_products
ALTER COLUMN product_name DROP DEFAULT;

CREATE TABLE table_items (
	item_id INTEGER PRIMARY KEY,
	item_name VARCHAR(100) NOT NULL
);

ALTER TABLE table_items
DROP CONSTRAINT table_items_pkey;

ALTER TABLE table_items
ADD PRIMARY KEY (item_id);

-- composite primary keys
CREATE TABLE t_grades (
	course_id VARCHAR(100) NOT NULL,
	student_id VARCHAR(100) NOT NULL,
	grade INT NOT NULL,
	PRIMARY KEY (course_id, student_id)
);

SELECT * FROM t_grades;

INSERT INTO t_grades (course_id, student_id, grade)
VALUES
	('MATH', 'S1', 50),
	('CHEM', 'S1', 70),
	('ENG', 'S2', 90);
	
ALTER TABLE t_grades
ADD PRIMARY KEY (course_id, student_id);

ALTER TABLE t_grades
ADD CONSTRAINT cool_constraint_pkey
PRIMARY KEY (course_id, student_id);

ALTER TABLE t_grades
DROP CONSTRAINT t_grades_pkey;
DROP TABLE t_grades;

-- foreign key constraints

-- parent table contains data from foregin/child table
CREATE TABLE IF NOT EXISTS t_products (
	product_id SERIAL,
	product_name VARCHAR(100) NOT NULL,
	supplier_id INTEGER NOT NULL
	PRIMARY KEY (product_id),
	FOREIGN KEY (supplier_id) REFERENCES t_suppliers (supplier_id)
);

-- child/foregin table
CREATE TABLE IF NOT EXISTS t_suppliers (
	supplier_id INT PRIMARY KEY,
	supplier_name VARCHAR(100) NOT NULL
);

INSERT INTO t_suppliers (supplier_id, supplier_name)
VALUES
	(1, 'supplier1'),
	(2, 'supplier2');

SELECT * FROM t_suppliers;

INSERT INTO t_products (product_name, supplier_id) VALUES
	('product1', 1),
	('product2', 2);
	
SELECT
	product_id,
	product_name,
	b.supplier_id,
	supplier_name
FROM t_products a
LEFT JOIN t_suppliers b ON
	a.supplier_id = b.supplier_id;
	
DELETE FROM t_suppliers
WHERE supplier_id = 2;
	
	
	
	
-- foreign key maintains data integriy

	
ALTER TABLE 
DROP CONSTRAINT
	
-- check constraint
CREATE TABLE staff (
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	birth_date DATE CHECK (birth_date > '1900-01-01'),
	joined_date DATE CHECK (joined_date > birth_date),
	salary NUMERIC CHECK (salary > 0)
);

SELECT * FROM staff;

INSERT INTO staff (salary) VALUES (1);

UPDATE STAFF 
SET salary = 0
WHERE staff_id = 2;

DROP TABLE prices;
CREATE TABLE IF NOT EXISTS prices (
	price_id SERIAL PRIMARY KEY,
	product_id INT NOT NULL,
	price_amount INT NOT NULL CHECK (price_amount > discount AND price > 0),
	discount NUMERIC CHECK (discount >= 0),
	FOREIGN KEY (product_id) REFERENCES t_products (product_id)
);
	
SELECT * FROM prices;

ALTER TABLE prices
ADD constraint price_check
CHECK (price_amount > discount);
	
ALTER TABLE prices
RENAME CONSTRAINT x TO x;