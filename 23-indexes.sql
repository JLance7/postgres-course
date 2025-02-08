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

