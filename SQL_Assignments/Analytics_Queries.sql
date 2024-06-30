-- Exercise 1
-- Get all the employees who is making more than average salary with in each department.

WITH avg_salary_cte AS (
    SELECT
    employee_id, department_id, salary,
    CAST(AVG(salary) OVER (PARTITION BY department_id) AS DECIMAL(18, 2)) as [avg_salary_dept]
    FROM employees
)

SELECT cte.department_id, cte.employee_id, d.department_name, cte.salary, avg_salary_dept as [avg_salary_expense]
FROM average_salary_cte cte
JOIN departments d
ON cte.department_id = d.department_id
WHERE cte.salary > avg_salary_dept
ORDER BY cte.department_id, cte.salary DESC

-- Exercise 2
-- Get cumulative salary with in each department for Finance and IT department along with department name.

SELECT e.employee_id, d.department_name, e.salary,
SUM(e.salary) OVER (PARTITION BY d.department_id) cum_salary_expense
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name = 'Finance' OR d.department_name = 'IT'
GROUP BY d.department_name, e.salary


-- Exercise 3
-- Get top 3 paid employees with in each department by salary (use dense_rank)


WITH dense_rank_cte AS(
    SELECT e.employee_id, e.department_id, d.department_name, e.salary,
    DENSE_RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) [employee_rank]
    FROM employees e
    JOIN departments d
    ON e.department_id = d.department_id
)
SELECT * FROM dense_rank_cte 
WHERE dense_rank_cte.employee_rank < 4
ORDER BY dense_rank_cte.department_id, dense_rank_cte.salary DESC

-- Exercise 4
-- Get top 3 products sold in the month of 2014 January by revenue.

WITH top_cte AS(
    SELECT product_id, product_name,
    CAST(SUM(order_item_subtotal) AS DECIMAL(18, 2)) revenue
    FROM orders o 
    JOIN order_items oi
    ON o.order_id = oi.order_item_order_id
    JOIN products p
    ON oi.order_item_product_id = p.product_id
    WHERE FORMAT(order_date, 'yyyy-MM') LIKE '2014-01%'
    AND (order_status = 'COMPLETED' OR order_status = 'CLOSED')
    GROUP BY product_id, product_name
)

SELECT TOP 3 *,
    RANK() OVER (ORDER BY revenue DESC) product_rank
FROM top_cte
ORDER BY revenue DESC

-- Exercise 5
-- Get top 3 products sold in the month of 2014 January under selected categories by revenue. The categories are Cardio Equipment and Strength Training.

WITH top_three_cte AS(
    SELECT category_id, category_name, product_id, product_name,
    ROUND(SUM(order_item_subtotal), 2) revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_item_order_id
    JOIN products p 
    ON oi.order_item_product_id = p.product_id
    JOIN categories c
    ON p.product_category_id = c.category_id
    WHERE (c.category_name = 'Cardio Equipment' OR c.category_name = 'Strength Training')
    AND (order_status = 'COMPLETED' OR order_status = 'CLOSED')
    AND FORMAT(order_date, 'yyyy-MM') LIKE '2014-01%'
    GROUP BY category_id, category_name, product_id, product_name
)
SELECT *, 
RANK() OVER (PARTITION BY category_id ORDER BY revenue DESC) product_rank
FROM top_three_cte
ORDER BY category_id, revenue DESC