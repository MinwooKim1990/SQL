--SELECT 'Select *' select all, select could select any name of column from table.
--FROM 'From Employees;' select table to pull.

SELECT * 
FROM Employees

--Limit 'Limit 5' return limited row.

SELECT * 
FROM Employees
LIMIT 5

-- WHERE is fitering with operator value

SELECT * 
FROM Employees
Where Employees Between 15 and 80
LIMIT 10

SELECT FirstName, LastName, Birthdate, Address, City, State 
FROM Employees
WHERE BirthDate = '1965-03-03 00:00:00'

-- In, Or, Not operator Use in the Where clause. 
SELECT *
FROM customers
WHERE country IN ('USA', 'Canada', 'Mexico');

SELECT *
FROM products
WHERE category = 'Electronics' OR category = 'Appliances';

SELECT *
FROM orders
WHERE NOT status = 'Cancelled';

SELECT *
FROM orders
WHERE customer_id IN ('C001', 'C002')
  AND (order_date >= '2022-01-01' OR order_total > 1000)
  AND NOT order_status = 'Cancelled';

-- Wildcards '%Pizza', 'Pizza%', '%Pizza%', 'S%E', 't%@gmail.com' not match NULLs. Takes longer to run.
SELECT TrackId, Name
FROM Tracks
WHERE Name LIKE 'All%'

SELECT CustomerId, Email
FROM Customers
WHERE Email LIKE "J%@gmail.com"

-- Order by Sorting sort data by particular columns and should be last clause.
SELECT InvoiceId, BillingCity, Total
FROM Invoices
WHERE BillingCity IN ('Brasilia','Edmonton','Vancouver')
ORDER BY InvoiceId DESC --ASC

-- Math operators *, /, +, -, (), %
SELECT product_name, unit_price * 1.1 AS new_price
FROM products
WHERE category = 'Electronics';

-- Aggregate functions AVG(), COUNT(), MIN(), MAX(), SUM() NULL will be ignored, DISTINCT will specify.
SELECT AVG(unit_price) AS average_price
FROM products
WHERE category = 'Electronics';

SELECT COUNT(*) AS total_customers
FROM customers
WHERE country = 'USA';

SELECT MIN(unit_price) AS min_price, MAX(unit_price) AS max_price
FROM products
WHERE category = 'Electronics';

SELECT SUM(quantity) AS total_units_sold
FROM order_details
WHERE product_id = 7;

-- Group by 
Select Region, Count(CustomerID) AS total_customers 
From Customers 
Group by Region;

Select CustomerID, Count(*) AS orders 
From Orders 
Where UnitPrice >=4 
Group by CustomerID 
Having Count(*) >=2;

SELECT FirstName,
       LastName,
       City,
       Email,
       COUNT(I.CustomerId) AS Invoices
FROM Customers C INNER JOIN Invoices I
ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId

-- Subqueries Adding that to the Where clause and processing the overall select statement. should have proper indentation.
SELECT Customer_name, Customer_state, 
       (SELECT COUNT(*) AS orders 
        FROM Orders 
        WHERE Orders.customer_id = Customer.customer_id) AS orders 
FROM customers 
ORDER BY Customer_name;

SELECT customer_name, city, state 
FROM customers 
WHERE city IN 
    (SELECT city 
     FROM sales_reps 
     WHERE commission_rate > 0.15);

SELECT Name,
       AlbumID
FROM Tracks
WHERE AlbumId IN (SELECT AlbumId
    FROM Albums
    WHERE Title = "Californication");

-- Joins
Select product_name, unit_price, company_name 
From suppliers Cross Join products;

SELECT Tracks.Name,
       A.Name AS Artist,
       Albums.Title AS Album,
       Tracks.TrackId
FROM ((Tracks INNER JOIN Albums
ON Tracks.AlbumId = Albums.AlbumId)
INNER JOIN Artists A
ON A.ArtistId = Albums.ArtistId); 

SELECT Name AS Artist,
       Artists.ArtistId,
       Albums.Title AS Album
FROM Artists
LEFT JOIN Albums
ON Artists.ArtistId = Albums.ArtistId
WHERE Album IS NULL

SELECT orders.order_id, customers.customer_name, orders.order_date, products.product_name, order_details.quantity
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE customers.country = 'USA';

-- Union
SELECT FirstName,
       LastName
FROM Employees
UNION
SELECT FirstName,
       LastName
FROM Customers
ORDER BY LastName DESC

SELECT customer_id, order_date, total_amount
FROM orders
WHERE order_date BETWEEN '2022-01-01' AND '2022-03-31'
UNION
SELECT customer_id, payment_date, amount
FROM payments
WHERE payment_date BETWEEN '2022-01-01' AND '2022-03-31';

-- Concatenations
SELECT CompanyName, ContactName, CompanyName || ' ('|| ContactName||')'
FROM customers

-- Trimming Strings
SELECT TRIM (" Your the best. ") AS TrimmedString;
             
-- Substring
SELECT first_name, SUBSTR (first_name,2,3)
FROM employees
WHERE department_id=60;

-- Upper and Lower
SELECT UPPER(column_name)
FROM table_name;

SELECT LOWER(column_name)
FROM table_name;

SELECT UCASE(column_name)
FROM table_name;

-- Date Formats
DATE = YYYY-MM-DD, DATETIME = YYYY-MM-DD HH:MI:SS, TIMESTAMP = YYYY-MM-DD HH:MI:SS
SELECT Birthdate
,STRFTIME('%Y', Birthdate) AS Year
,STRFTIME('%m', Birthdate) AS Month
,STRFTIME('%d', Birthdate) AS Day
,DATE(('now') - Birthdate) AS Age
FROM employees

SELECT DATE('now')

SELECT STRFTIME('%Y %m %d', 'now')

-- Case Statement
CASE
When C1 THEN E1
WHEN C2 THEN E2
ELSE [result else]
END

CASE input_expression
  WHEN when_expression THEN result_expression [...n]
  [ ELSE else_result_expression ]
END

SELECT employeeid, firstname, lastname, city, CASE city WHEN 'Calgary' THEN 'Calgary'
ELSE ' Other' END calgary
FROM Employees
ORDER BY LastName, FirstName;

SELECT trackid, name, bytes
,CASE
WHEN bytes < 300000 THEN 'small'
WHEN bytes >= 300001 AND bytes <= 500000 THEN 'medium'
WHEN bytes >= 500001 THEN 'large'
ELSE 'Other'
END bytescategory
FROM tracks;

-- Creating a View
CREATE VIEW my_view
AS SELECT r.regiondescription, t.territorydescrption, e.Lastname, e.Firstname, e.Hiredate, e.Reportsto
FROM Region r
INNER JOIN Territories t on r.regionid = t.regionid
INNER JOIN Employeeterritories et on t.TerritoryID =et.TerritoryID
INNER JOIN Employees e on et.employeeid = e.EmployeeID
