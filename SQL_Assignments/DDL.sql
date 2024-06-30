
SELECT MAX(order_id) FROM orders
SELECT MAX(order_item_id) FROM order_items
SELECT MAX(customer_id) FROM customers
SELECT MAX(product_id) FROM products
SELECT MAX(category_id) FROM categories
SELECT MAX(department_id) FROM departments


CREATE SEQUENCE orders_sequence
INCREMENT 1
START 68884
OWNED BY orders.order_id;

/*
-- Test
INSERT INTO orders(order_id, order_date, order_customer_id, order_status)
VALUES(nextval('orders_sequence'), CURRENT_DATE, 123, 'COMPLETED')
*/

CREATE SEQUENCE orders_items_sequence
INCREMENT 1
START 172199
OWNED BY order_items.order_item_id

CREATE SEQUENCE customers_sequence
INCREMENT 1
START 10950
OWNED BY customers.customer_id

CREATE SEQUENCE products_sequence
INCREMENT 1
START 1346
OWNED BY products.product_id

CREATE SEQUENCE categories_sequence
INCREMENT 1
START 59
OWNED BY categories.category_id

CREATE SEQUENCE departments_sequence
INCREMENT 1
START 8
OWNED BY departments.department_id

ALTER TABLE orders WITH CHECK
ADD CONSTRAINT order_customer_id FOREIGN KEY(order_customer_id) REFERENCES customers(customer_id)

ALTER TABLE order_items WITH CHECK
ADD CONSTRAINT order_item_order_id FOREIGN KEY(order_item_order_id) REFERENCES orders(order_id)

ALTER TABLE order_items WITH CHECK
ADD CONSTRAINT order_item_product_id FOREIGN KEY(order_item_product_id) REFERENCES products(product_id)


-- Products contain category_id not found in categories
ALTER TABLE products WITH CHECK
ADD CONSTRAINT product_category_id FOREIGN KEY(product_category_id) REFERENCES categories(category_id)

-- Allows product_category_id to be NULL
ALTER TABLE products
ALTER COLUMN product_category_id INT NULL

-- Sets any product_category_id not in categories to NULL
UPDATE products
SET product_category_id = NULL
WHERE product_category_id NOT IN(
   SELECT category_id
   FROM categories
)

ALTER TABLE categories WITH CHECK
ADD CONSTRAINT category_department_id FOREIGN KEY(category_department_id) REFERENCES departments(department_id)

ALTER TABLE categories
ALTER COLUMN category_department_id INT NULL

UPDATE categories 
SET category_department_id = NULL
WHERE category_department_id NOT IN(
   SELECT department_id 
   FROM departments
)


SELECT 
     KCU1.CONSTRAINT_NAME AS 'FK_CONSTRAINT_NAME'
   , KCU1.TABLE_NAME AS 'FK_TABLE_NAME'
   , KCU1.COLUMN_NAME AS 'FK_COLUMN_NAME'
   , KCU1.ORDINAL_POSITION AS 'FK_ORDINAL_POSITION'
   , KCU2.CONSTRAINT_NAME AS 'UQ_CONSTRAINT_NAME'
   , KCU2.TABLE_NAME AS 'UQ_TABLE_NAME'
   , KCU2.COLUMN_NAME AS 'UQ_COLUMN_NAME'
   , KCU2.ORDINAL_POSITION AS 'UQ_ORDINAL_POSITION'
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU1
ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG 
   AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA
   AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2
ON KCU2.CONSTRAINT_CATALOG = 
RC.UNIQUE_CONSTRAINT_CATALOG 
   AND KCU2.CONSTRAINT_SCHEMA = 
RC.UNIQUE_CONSTRAINT_SCHEMA
   AND KCU2.CONSTRAINT_NAME = 
RC.UNIQUE_CONSTRAINT_NAME
   AND KCU2.ORDINAL_POSITION = KCU1.ORDINAL_POSITION
