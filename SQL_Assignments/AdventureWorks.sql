-- Basic Queries

-- 1. Select all products.

SELECT * FROM Production.Product

-- 2. Select all employees and their job titles.

SELECT CONCAT_WS(' ', FirstName, LastName) as [Name], JobTitle 
FROM Person.Person p 
INNER JOIN 
HumanResources.Employee hr 
ON hr.BusinessEntityID = p.BusinessEntityID

-- 3. List all sales orders from a specific customer (e.g., CustomerID = 295)

SELECT * FROM Sales.SalesOrderDetail  sod
INNER JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE CustomerID = 11073

-- 4. Find the total due by each customer.

SELECT CustomerID, ROUND(SUM(TotalDue), 2) as [Total Due]
FROM Sales.SalesOrderDetail  sod
LEFT JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY CustomerID
ORDER BY CustomerID

-- 5. Find all suppliers (vendors) and their contact information.

SELECT v.BusinessEntityID, v.AccountNumber, v.Name, p.PhoneNumber, e.EmailAddress
FROM Purchasing.Vendor v
LEFT JOIN
(Person.PersonPhone p
JOIN Person.EmailAddress e
ON e.BusinessEntityID = p.BusinessEntityID)
ON v.BusinessEntityID = p.BusinessEntityID

-- 6. List all product categories and their subcategories.

SELECT pc.ProductCategoryID, pc.Name as [Product Category], STRING_AGG(psc.Name, ', ') as [Product Subcategory Name]
FROM Production.ProductCategory pc
JOIN 
Production.ProductSubcategory psc
ON pc.ProductCategoryID = psc.ProductCategoryID
GROUP BY pc.ProductCategoryID, pc.Name
ORDER BY pc.ProductCategoryID

-- 7. Find all products that have been discontinued.

SELECT * FROM Production.Product
WHERE DiscontinuedDate IS NOT NULL 

-- 8. Get the total quantity ordered for each product.

SELECT p.productID, p.Name, COALESCE(SUM(OrderQty), 0) as [Total Quantity] FROM 
Production.Product p
LEFT JOIN
Purchasing.PurchaseOrderDetail pod
ON p.ProductID = pod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY p.ProductID

-- 9. List all addresses associated with a specific customer (e.g., CustomerID = 295).

SELECT AddressLine1, City, StateProvinceID, PostalCode
FROM
(SELECT ShipToAddressID
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000) sub
JOIN Person.Address
ON sub.ShipToAddressID = Person.Address.AddressID
GROUP BY AddressLine1, City, StateProvinceID, PostalCode

-- 10. Find the top 5 products by total quantity sold.

SELECT TOP 5 p.productID, p.Name, COALESCE(SUM(OrderQty), 0) as [Total Quantity] FROM 
Production.Product p
LEFT JOIN
Purchasing.PurchaseOrderDetail pod
ON p.ProductID = pod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY [Total Quantity] DESC

-- Challenging Queries with Built-in Functions

-- 1. Get the number of employees hired each year.

SELECT FORMAT(HireDate, 'yyyy') as [Year], COUNT(1) as [Number Hired]
FROM HumanResources.Employee
GROUP BY FORMAT(HireDate, 'yyyy')
ORDER BY [Year]

-- 2. Find the average order amount for each product.

SELECT p.productID, p.Name, COALESCE(CAST(AVG(OrderQty) AS DECIMAL (18, 2)), 0) as [Average Quantity] 
FROM Production.Product p
LEFT JOIN
Purchasing.PurchaseOrderDetail pod
ON p.ProductID = pod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY p.ProductID

-- 3. Determine the month with the highest sales in a specific year (e.g., 2014).

SELECT TOP 1 DATENAME(month, OrderDate) AS [Month], COALESCE(CAST(SUM(TotalDue) AS DECIMAL(18, 2)), 0) as [Sales]
FROM Purchasing.PurchaseOrderHeader
WHERE FORMAT(OrderDate, 'yyyy') LIKE '2014'
GROUP BY DATENAME(month, OrderDate)
ORDER BY Sales DESC

-- 4. Retrieve products that have a name length greater than the average product name length.

WITH product_view AS (
    SELECT ProductID, Name, LEN(NAME) as [Length]
    FROM Production.Product
    GROUP BY ProductID, Name
)

SELECT * FROM product_view
WHERE product_view.Length >
(SELECT CAST(AVG(product_view.Length) AS DECIMAL(18, 2)) FROM product_view)


-- 5. Get the next day of the week for all order dates in a table.

SELECT PurchaseOrderID, OrderDate, DATEADD(DAY, 1, OrderDate) as [Next Day]
FROM Purchasing.PurchaseOrderHeader
GROUP BY PurchaseOrderID, OrderDate

-- 6. Calculate the age of each employee.

SELECT CONCAT_WS(' ', p.FirstName, p.LastName) as [Name], e.BirthDate, DATEDIFF(day, e.BirthDate, GETDATE()) / 365 as Age
FROM HumanResources.Employee e
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID

-- 7. Find the most recent sales order for each customer.

WITH recent_sales_view AS(
SELECT CustomerID, SalesOrderID, MIN(OrderDate) as [Most_Recent],
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) rn
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, SalesOrderID, OrderDate)

SELECT CustomerID, SalesOrderID, Most_Recent
FROM recent_sales_view
WHERE rn = 1
ORDER BY CustomerID

-- 8. Get the total number of orders placed on the last day of each month.

SELECT FORMAT(EOMonth(OrderDate), 'MM-dd') as [Last Day of Month], COUNT(1) as [Number of Orders]
FROM Sales.SalesOrderHeader
WHERE FORMAT(OrderDate, 'MM-dd') = FORMAT(EOMonth(OrderDate), 'MM-dd')
GROUP BY FORMAT(EOMonth(OrderDate), 'MM-dd')

-- 9. Retrieve the list of products with names that start with vowels.

SELECT * FROM Production.Product
WHERE SUBSTRING(name, 1, 1) IN ('a', 'e', 'i', 'o', 'u', 'y')

-- 10. Calculate the percentage of total sales for each salesperson compared to overall sales.

SELECT 
p.BusinessEntityID, CONCAT_WS(' ', p.FirstName, p.LastName) as [Name],
(SalesYTD/SUM(SalesYTD) OVER () * 100) as [Percentage]
FROM Sales.SalesPerson sp
JOIN Person.Person p
ON sp.BusinessEntityID = p.BusinessEntityID

-- Basic Queries with Analytics Functions

-- 1. Calculate the row number for all orders in June of 2011 sorted by SalesOrderID

SELECT 
ROW_NUMBER() OVER(ORDER BY OrderDate) as [Row #], 
*
FROM Sales.SalesOrderHeader
WHERE FORMAT(OrderDate, 'yyyy-MM') LIKE '2011-06%'

-- 2. Compare information for the current sales order to the total amount due for the day the order was placed.

SELECT 
SalesOrderID,
SubTotal as [Current Sales],
SUM(SubTotal) OVER (PARTITION BY OrderDate) as [Total for day]
FROM Sales.SalesOrderHeader

-- 3. Calculate the 3 Day moving average for order totals in SalesOrderHeader table

SELECT 
AVG(SubTotal) OVER (PARTITION BY OrderDate ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as [3 day average]
FROM Sales.SalesOrderHeader

-- 4. For each product, rank each order by which has the highest quantity of that product ordered.

SELECT SalesOrderID, ProductID, OrderQty,
ROW_NUMBER() OVER (
        PARTITION BY SalesOrderID ORDER BY OrderQty DESC
    ) [Rank]
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderDetailID

-- 5. Compare the date an order was placed on to the previous and next time that someone with the same account number placed an order-

SELECT OrderDate, AccountNumber,
LAG(OrderDate, 1) OVER(PARTITION BY AccountNumber ORDER BY OrderDate) as [Previous Order],
LEAD(OrderDate, 1 )OVER(PARTITION BY AccountNumber ORDER BY OrderDate) as [Next Order]
FROM Sales.SalesOrderHeader

-- Challenging Queries with Analytics Functions

-- 1. Determine the top 5 products with the highest average monthly sales and their growth rate from the previous month.

SELECT * 
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderDetailID = soh.SalesOrderID

-- 2. Identify customers who have increased their monthly spending for three consecutive months.
-- 3. Compute the Year-over-Year (YoY) sales growth for each product category.
-- 4. Rank employees based on their total sales, considering only those who made sales in at least three different months.
-- 5. Identify the most profitable day of the week over the past year.