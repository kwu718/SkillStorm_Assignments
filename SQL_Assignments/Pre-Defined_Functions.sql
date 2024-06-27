-- Exercise 1

SELECT FORMAT(user_dob, 'yyyy') AS [created_year], count(user_id) as [user_count]
FROM users
GROUP BY FORMAT(user_dob, 'yyyy')
ORDER BY created_year

-- Exercise 2

SELECT user_id, user_dob, user_email_id, DATENAME(dw, user_dob) as [user_day_of_birth]
FROM users
WHERE DATENAME(month, user_dob) = 'MAY'
ORDER BY FORMAT(user_dob, 'mm-dd')

-- Exercise 3

SELECT user_id, UPPER(CONCAT_WS(' ', user_first_name, user_last_name)) as user_name, user_email_id, created_ts, CAST(FORMAT(created_ts, 'yyyy') as DECIMAL(18,1)) as [created_year]
FROM users
WHERE FORMAT(created_ts, 'yyyy') = 2019
ORDER BY user_name


-- Exercise 4

SELECT user_gender = CASE user_gender
        WHEN 'M' THEN 'Male'
        WHEN 'F' THEN 'Female'
        WHEN 'N' THEN 'Non-Binary'
        ELSE 'Not Specified'
        END,
        COUNT(1) as [user_count]
FROM users
GROUP BY user_gender
ORDER BY user_count DESC;

-- Exercise 5

SELECT user_id, user_unique_id,
    user_unique_id_last4 = CASE
    WHEN LEN(REPLACE(user_unique_id, '-', '')) < 9 THEN 'Invalid Unique Id'
    WHEN user_unique_id IS NULL THEN 'Not Specified'
    ELSE RIGHT(REPLACE(user_unique_id, '-', ''), 4)
    END
FROM users

SELECT * FROM users
WHERE user_unique_id IS NULL

-- Exercise 6


SELECT CAST(SUBSTRING(user_phone_no, 2, CHARINDEX(' ', user_phone_no) - 2) AS INT)  as [country_code], COUNT(user_phone_no) as [user_count]
FROM users
WHERE user_phone_no IS NOT NULL
GROUP BY SUBSTRING(user_phone_no, 2, CHARINDEX(' ', user_phone_no) - 2)
ORDER BY country_code

-- Exercise 7 

SELECT COUNT(1) as count
FROM order_items
WHERE CONVERT(decimal, order_item_product_price * order_item_quantity) != CONVERT(decimal, order_item_subtotal)

-- Exercise 8


SELECT 
day_type = CASE DATENAME(dw, order_date)
WHEN 'Saturday' THEN 'Weekend days'
WHEN 'Sunday' THEN 'Weekend days'
ELSE 'Week days'
END, COUNT(1) as [order_count]
FROM orders
WHERE FORMAT(order_date, 'yyyy-MM') LIKE '2014-01%'
GROUP BY CASE DATENAME(dw, order_date)
WHEN 'Saturday' THEN 'Weekend days'
WHEN 'Sunday' THEN 'Weekend days'
ELSE 'Week days'
END
ORDER BY order_count
