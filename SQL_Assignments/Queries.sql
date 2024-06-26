SELECT order_customer_id, COUNT(1) as order_count 
FROM orders
WHERE order_date >= '2014-01-01' AND order_date <= '2014-01-30'
GROUP BY order_customer_id
ORDER BY order_count DESC, order_customer_id;

SELECT * FROM orders