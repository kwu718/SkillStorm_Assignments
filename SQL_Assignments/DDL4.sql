
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

SELECT * FROM orders

ALTER TABLE orders WITH CHECK
ADD CONSTRAINT order_customer_id FOREIGN KEY(order_customer_id) references customers(customer_id)

SELECT * FROM orders
ORDER BY order_customer_id