-- indexes
-- improves access of data in db
-- add speed to data access but add cost to data modification
-- put index on table column
CREATE INDEX idx_table_col
CREATE UNIQUE INDEX idx_u_table_col

CREATE INDEX idx_orders_order_date ON orders (order_date);

CREATE INDEX idx_orders_ship_city ON orders (ship_city);

CREATE INDEX idx_orders_customer_id_order_id ON orders (customer_id, order_id);

CREATE INDEX idx_shippers_company_name ON shippers (company_name);

-- primary key uses unique index
-- if unique index for two cols, combined values in these cols cannot be duplicated
CREATE UNIQUE INDEX idx_u_products_product_id ON products (product_id);

CREATE UNIQUE INDEX idx_u_employees_employee_id ON employees (employee_id);

CREATE UNIQUE INDEX idx_u_orders_order_id_customer_id ON orders (order_id, customer_id);
CREATE UNIQUE INDEX idx_u_employees_employee_id_hire_date ON employees (employee_id, hire_date);

-- list all indexes
SELECT
	*
FROM pg_indexes
WHERE tablename = 'employees'
ORDER BY
	tablename,
	indexname;

SELECT
	PG_SIZE_PRETTY(PG_INDEXES_SIZE('orders'));
	
CREATE INDEX idx_suppliers_region ON suppliers (region);
CREATE INDEX idx_suppliers_supplier_id ON suppliers (supplier_id);

SELECT *
FROM pg_stat_all_indexes
WHERE relname = 'orders' -- table name
ORDER BY relname, indexrelname;

DROP index idx_suppliers_region;

CREATE INDEX idx_orders_order_date_on ON orders
USING hash (order_date);

EXPLAIN SELECT * FROM orders ORDER BY order_date;

EXPLAIN (FORMAT YAML) SELECT * FROM orders WHERE order_id = 1;

-- generate millions of recoreds
CREATE TABLE t_big(
	id serial, 
	name text
);

INSERT INTO t_big (name)
SELECT 'Adam' FROM generate_series(1, 2000);

SELECT * FROM t_big;

SHOW cpu_operator_cost;

SELECT
	pg_size_pretty(pg_indexes_size('t_big')) AS "size_of_indexes_for_table",
	pg_size_pretty(pg_total_relation_size('t_big')) AS "size_of_table";
	
CREATE INDEX idx_t_big_id ON t_big (id);

EXPLAIN ANALYZE SELECT * FROM t_big WHERE id = 2000;

EXPLAIN SELECT * FROM t_big
WHERE id = 20 OR id = 40;


CREATE INDEX idx_t_big_name ON t_big (name);

CREATE TABLE t_big_random AS 
SELECT * FROM t_big ORDER BY random();

SELECT * FROM t_big_random;

CREATE INDEX idx_t_big_random_id ON t_big_random (id);

SELECT * 
FROM pg_stats
WHERE tablename IN ('t_big', 't_big_random');

-- partial index for reducting index size
CREATE INDEX idx_p_t_big_name ON t_big (name)
WHERE name NOT IN ('Adam', 'Linda');

CREATE TABLE t_dates AS 
SELECT d, repeat(md5(d::text), 10) AS padding
FROM generate_series(TIMESTAMP '1880-01-01',
					TIMESTAMP '2100-01-01',
					 INTERVAL '1 DAY'
					) s(d);
SELECT * FROM t_dates;					
VACUUM ANALYZE t_dates;

EXPLAIN SELECT * FROM t_dates WHERE d BETWEEN '2020-01-01' AND '20205-01-09';

CREATE INDEX idx_t_dates_d ON t_dates (d);

-- expression index
CREATE INDEX idx_expr_t_dates ON t_dates (EXTRACT(day FROM d));

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE EXTRACT(day FROM d) = 1;

-- CREATE INDEX CONCCURENTLY (allows you to access table while index is created)
CREATE INDEX CONCURRENTLY idx_t_big_name2 ON t_big (name);

-- invalidate index, don't use index without deleting it
CREATE INDEX idx_orders_ship_country ON orders (ship_country);

EXPLAIN SELECT * FROM orders WHERE ship_country = 'USA';
UPDATE pg_index...

-- rebuild index, clean slate
REINDEX INDEX idx_orders_customer_id_order_id;