CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(150),
	age INT
);

SELECT * FROM customers;

INSERT INTO customers (first_name, last_name, email, age)
VALUES ('Josh', 'Lanctot', 'josh@gmail.com', 23);

INSERT INTO customers (first_name, last_name, email, age)
VALUES 
	('1', '2', 'a@g.com', 24),
	('3', '5', 'b@h.com', 25),
	('6', '7', 'c@j.com', 26);
	
INSERT INTO customers (first_name)
VALUES ('Bob')
RETURNING first_name;

SELECT * FROM customers ORDER BY customer_id ASC;

-- update column in row
UPDATE customers
SET email = 'a2@b.com'
WHERE customer_id = 4
RETURNING *;

UPDATE customers 
SET email = 'a4@b.com',
	age = 30
WHERE customer_id = 7;

UPDATE customers
SET is_enable = 'Y';

SELECT * FROM customers;

-- delete record
DELETE FROM customers WHERE customer_id = 7;

-- upsert, updates row if it already exists, else insert new row (update or insert combination)
CREATE TABLE t_tags(
	id SERIAL PRIMARY KEY,
	tag TEXT UNIQUE,
	update_date TIMESTAMP DEFAULT NOW()
);

SELECT * FROM t_tags;

INSERT INTO t_tags (tag) VALUES
('Pen'),
('Pencil');

-- insert a record, on conflict do nothing, if data already exists do nothing
INSERT INTO t_tags (tag)
VALUES
	('Pen')
ON CONFLICT (tag) DO NOTHING;

INSERT INTO t_tags (tag)
VALUES
	('Pen')
ON CONFLICT (tag) 
DO 
	UPDATE SET 
		tag = EXCLUDED.tag || '1',
		update_date = NOW();