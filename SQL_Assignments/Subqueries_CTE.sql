-- Exercise 1

SELECT category_name FROM
(SELECT category_name, COUNT(product_id) as [Product_Count]
FROM
categories LEFT JOIN
products on product_category_id = category_id
GROUP BY category_name) sub
WHERE [Product_Count] > 5

-- Exercise 2
SELECT * FROM orders
WHERE order_customer_id IN
(SELECT order_customer_id
FROM orders
LEFT JOIN customers
ON order_customer_id = customer_id
GROUP BY order_customer_id
HAVING COUNT(1) > 10)

-- Exercise 3

SELECT product_name,
(SELECT ROUND(AVG(order_item_product_price), 2)
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_item_order_id
WHERE FORMAT(o.order_date, 'yyyy-MM') LIKE '2013-10%'
) as [Average Price]
FROM products

-- Exercise 4

/*
CREATE VIEW sum_view AS
(SELECT o.order_id, ROUND(SUM(order_item_subtotal), 2) as [order_sum]
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_item_order_id
GROUP BY o.order_id)
GO
*/

SELECT * FROM orders
WHERE order_id IN(
SELECT order_id
FROM sum_view
WHERE sum_view.order_sum > (SELECT ROUND(AVG(sum_view.order_sum), 2) FROM sum_view))
ORDER BY order_id

-- Exercise 5

WITH category_product_count AS(
SELECT c.category_name, c.category_id, COUNT(p.product_id) as [Product Count]
FROM categories c
LEFT JOIN products p 
ON  p.product_category_id = c.category_id
GROUP BY c.category_name, c.category_id) 

SELECT TOP 3 * FROM category_product_count
ORDER BY [Product Count] DESC, category_id

-- Exercise 6

WITH customer_sum_cte AS(
SELECT o.order_customer_id, ROUND(SUM(oi.order_item_subtotal), 2) as [customer_sum]
FROM
orders o
JOIN order_items oi 
ON o.order_id = oi.order_item_order_id
WHERE FORMAT(order_date, 'MM') = '12'
GROUP BY o.order_customer_id)
SELECT * FROM customers
WHERE customer_id IN(
SELECT order_customer_id FROM customer_sum_cte
WHERE customer_sum > (SELECT ROUND(AVG(customer_sum), 2) FROM customer_sum_cte)
)
