--  Kyrilous Nasr
--  Assignment #2 (Chapter 3: Joins)

-- 1.) List each customer and the total number of orders they have placed
-- Purpose: We can use this data to find our top 10 loyal customers based on number of orders.
SELECT c.CustomerName AS "Customer Name", COUNT(c.CustomerID) AS "Total Orders" -- Count how many orders each customer has placed
FROM Sales.Orders AS o
JOIN Sales.Customers AS c
	ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName, c.CustomerID -- Group the results by customer so each customer has one row
ORDER BY [Total Orders] DESC -- Sort the results so the customers with the most orders appear first




-- 2.) Which customers placed an order in 2016 and which salesman was assigned to them.
-- Purpose: This can help a company assess sales performance for a given year (2016 in this query). 
SELECT c.CustomerName AS Customer, p.FullName AS "Sales Person", o.OrderDate
FROM Sales.Orders AS o
JOIN Sales.Customers as c -- Join with Customers table to link each order to the customer who placed it
	ON o.CustomerID = c.CustomerID
JOIN Application.People as P -- Join with People table to find the salesperson assigned to each order
	ON o.SalespersonPersonID = p.PersonID
WHERE YEAR(o.OrderDate) = 2016  -- Filter results to only include orders made in the year 2016
ORDER BY c.CustomerName	-- Sort results alphabetically by customer name







-- 3.) List top 10 most ordered stock items along with their supplier names.
-- This query can help the company get a guage of what products they should stock up more on. We should have more of the most sold
-- item in stock compared to an item that doesn't sell that often.
SELECT TOP 10 si.StockItemName, SUM(st.Quantity) AS TotalOrdered, s.SupplierName AS Supplier
FROM Warehouse.StockItemTransactions AS st -- Start with the Stock Item Transactions table (records each transaction of stock items)
JOIN Warehouse.StockItems AS si		-- Join with StockItems table to get item details such as name.
	ON st.StockItemID = si.StockItemID
JOIN Purchasing.Suppliers as s		-- Join with Suppliers table to find which supplier provides each item
	ON s.SupplierID = si.SupplierID
GROUP BY si.StockItemName, s.SupplierName  -- Group by item and supplier so totals can be calculated correctly
ORDER BY TotalOrdered DESC





-- 4.) List all stock items along with the quantity in stock.
-- Companies may want to know this information to get an idea of what products they should order for their next delivery depending on current stock.
SELECT si.StockItemName AS Item, sih.QuantityOnHand AS "Total Quantity"
FROM Warehouse.StockItems AS si -- Need Warehouse.StockItems to have access to the name of a given item in order based off it's itemID.
JOIN Warehouse.StockItemHoldings as sih -- Joining StockitemHoldings to have access to the ammount of a given item that is currently in stock. 
	ON si.StockItemID = si.StockItemID
ORDER BY [Total Quantity] DESC



-- 5.) List all employees along with the total number of sales they have made
-- Companies can use this information to see their most impactful sales employees. This can also help managers see the productivy levels of all their employees.
SELECT p.FullName AS EmployeeName, COUNT(o.SalespersonPersonID) AS "Total Sales" -- Count sales person ID's because every order has a SalesPersonID attached to it.
FROM Sales.Orders AS o
JOIN Application.People AS p  -- Joining application.people so that we can access employee names through their Sales Person ID's.
	ON p.PersonID = o.SalespersonPersonID
GROUP BY p.PersonID, p.FullName
ORDER BY [Total Sales] DESC -- Display all data in decending order of total sales. That way, first entry is most productive employee, and last entry is least productive.




-- 6.) Find employee who processed the largest number of sales 
--(Similiar to last query, except now we are selecting the TOP 1, which gives us a single output of the most productive Sales Person.)
SELECT TOP 1 p.FullName as EmployeeName, COUNT(o.SalespersonPersonID) as "Total Sales"  -- Count sales person ID's because every order has a SalesPersonID attached to it.
FROM Sales.Orders as o																	-- Selecting TOP 1 to return the Employee at the top of the list (Most sales)
JOIN Application.People as p    -- Joining application.people so that we can access employee names through their Sales Person ID's.
	ON p.PersonID = o.SalespersonPersonID
GROUP BY p.FullName
ORDER BY [Total Sales] DESC		-- Display all data in decending order of total sales. That way, first entry is most productive employee, and last entry is least productive.
	


-- 7.) Find the month with the highest sales revenue
-- Purpose: We can use this data to get a idea of what month we should overstock on items due to a surplus of sales, or spot seasional trends.
SELECT
-- Calculate total revenue for that month by multiplying quantity x unit price
YEAR(o.OrderDate) AS yearDate, MONTH(o.OrderDate) AS OrderMonth, SUM(ol.Quantity * ol.UnitPrice) as "Total Revenue" 
FROM Sales.OrderLines AS ol
JOIN Sales.Orders AS o	-- Join with Orders table to get the order date
	ON o.OrderID = ol.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)	-- Group results by year and month so we get one row per month
ORDER BY [Total Revenue] DESC	--Sort results by total revenue in descending order




-- 8.) Find the total number of customers per state.
/* Purpose: Companies can use this information to find out what states they should target for marketing campaigns 
to grow their customer base in cities that they aren't popular in yet. */
SELECT sp.StateProvinceName, COUNT(c.CustomerID) AS "Total Customers" -- Count customer ID's per state to know how many customers exist in that state.
FROM Sales.Customers AS c
JOIN Application.Cities as ci -- Join application.cities because it contains the pointer to StateProvinces, where we can access the state that customer lives in.
	ON ci.CityID = c.DeliveryCityID
JOIN Application.StateProvinces as sp
	ON sp.StateProvinceID = ci.StateProvinceID
GROUP BY sp.StateProvinceName -- Groups all customers by the state that they reside in.





-- 9.) Count how many orders placed in 2016.
  /* Purpose: Get an understanding how company is performing. If we see that we made 40,000 in 2016, and then 90,000 in 2017, there is a 
clear indicator that the company is growing.*/
SELECT COUNT(o.OrderDate) AS "Total Orders In 2016" -- Counting all orders where the orderyear of that date is equal to 2016.
FROM Sales.Orders AS o
WHERE YEAR(o.OrderDate) = '2016'


-- 10.) List top 10 products (By units sold)
/* Purpose: Companies can use this to know which products they make the most revenue on. Using this data,
they can offer things like sales on those items, or plan a larger order for the next restock. */
SELECT TOP 10 si.StockItemName, SUM(ol.Quantity) AS Quantity -- Selecting top 10 stock item names that have the most units sold.
FROM Sales.Orders AS o
JOIN Sales.OrderLines AS ol		-- Joining Sales.OrderLines becaause this table contains the quantity of items within an order.
	ON ol.OrderID = o.OrderID
JOIN Warehouse.StockItems AS si  --Joining Warehouse.StockItems beacuse this table contains the names of all the items we have in stock.
	ON si.StockItemID = ol.StockItemID
GROUP BY si.StockItemName 
ORDER BY Quantity DESC
