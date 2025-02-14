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