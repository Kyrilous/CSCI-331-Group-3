-- Count how many customers exist
Select COUNT(*) AS TotalCustomers
FROM Sales.Customers
GO


-- Find most recent order date.
SELECT MAX(OrderDate) AS LatestOrder
FROM Sales.Orders
GO


-- Find oldest customer by account date opening.
SELECT TOP 1 c.CustomerName, c.AccountOpenedDate
FROM Sales.Customers c
ORDER BY AccountOpenedDate ASC 
GO


-- List top 10 most expensive products for sale
SELECT TOP 10 Warehouse.StockItems.UnitPrice, Warehouse.StockItems.StockItemName
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC
GO


-- Find employee who processed the largest number of sales
SELECT TOP 1 p.FullName as SalesPerson, COUNT(i.SalespersonPersonID) AS Total_Sales
FROM Sales.Invoices i
JOIN Application.People p
	ON i.SalespersonPersonID = p.PersonID
GROUP BY p.FullName
GO


-- Find total revenue generated in the year 2016
SELECT SUM(Sales.OrderLines.UnitPrice * Sales.OrderLines.Quantity) AS TotalRevenue
FROM Sales.OrderLines
JOIN Sales.Orders
	ON Sales.OrderLines.OrderID = Sales.Orders.OrderID
WHERE YEAR(Sales.Orders.OrderDate) = 2016
GO



-- Find the month with the highest sales revenue
SELECT TOP 1 YEAR(OrderDate) AS order_year,MONTH(OrderDate) AS order_month,SUM(UnitPrice * Quantity) AS revenue
FROM Sales.OrderLines ol
JOIN Sales.Orders o
	ON ol.OrderID = o.OrderID
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY revenue DESC
GO


-- Find all products that cost more than 100$
SELECT  Warehouse.StockItems.StockItemName, Warehouse.StockItems.UnitPrice
FROM Warehouse.StockItems
WHERE UnitPrice > 100
ORDER BY UnitPrice DESC
GO


-- List top 5 least selling products
SELECT TOP 5 si.StockItemName, SUM(ol.Quantity) AS Quantity
FROM Sales.OrderLines ol
JOIN Warehouse.StockItems si
	ON si.StockItemID = ol.StockItemID
GROUP BY si.StockItemName
ORDER BY Quantity ASC
GO


-- Find the total number of customers that reside in the USA
SELECT COUNT(DISTINCT c.CustomerID) AS US_Customers
FROM Sales.Customers AS c
JOIN Application.Cities AS ci
	ON c.DeliveryCityID = ci.CityID
JOIN Application.StateProvinces AS sp
	ON ci.StateProvinceID = sp.StateProvinceID
JOIN Application.Countries AS co
	ON sp.CountryID = co.CountryID
WHERE co.CountryName = 'United States';
GO

-- Find the total number of customers per state.
SELECT sp.StateProvinceName, COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Sales.Customers c
JOIN Application.Cities ci
  ON c.DeliveryCityID = ci.CityID
JOIN Application.StateProvinces sp
  ON ci.StateProvinceID = sp.StateProvinceID
GROUP BY sp.StateProvinceName
ORDER BY CustomerCount DESC;



-- List top 10 loyal customers (Customers With The Most Orders)
SELECT TOP 10 c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Sales.Customers AS c
JOIN Sales.Orders AS o
	ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalOrders DESC;
GO

-- Find average unit price of all stock items.
SELECT AVG(si.UnitPrice)
From Warehouse.StockItems si



-- Count how many orders placed in 2016
SELECT COUNT(*) AS TotalOrders
FROM Sales.Orders
WHERE YEAR(Sales.Orders.OrderDate) = 2016
GO


-- (15) Total number of products per color
SELECT 
    c.ColorName,
    COUNT(si.StockItemID) AS TotalProducts
FROM Warehouse.StockItems AS si
JOIN Warehouse.Colors AS c
    ON si.ColorID = c.ColorID
GROUP BY c.ColorName
ORDER BY TotalProducts DESC;
GO


-- Rank sales people by total sales
SELECT P.FullName as SalesPerson, COUNT(i.SalespersonPersonID) as Total_Sales 
FROM Sales.Invoices i
JOIN Application.People p
	ON i.SalespersonPersonID = p.PersonID
GROUP BY p.FullName
ORDER BY Total_Sales DESC
GO



-- List top 10 products (By units sold)
SELECT TOP 10 
	Warehouse.StockItems.StockItemName, SUM(Sales.OrderLines.Quantity) AS TotalUnitsSold
FROM Sales.OrderLines
JOIN Warehouse.StockItems
	ON Sales.OrderLines.StockItemID = Warehouse.StockItems.StockItemID
GROUP BY Warehouse.StockItems.StockItemName
ORDER BY TotalUnitsSold DESC
GO


-- Find the customer with the largest order (Customer who has spent the most money in one order)
SELECT TOP 1
	o.CustomerID ,o.OrderId, sc.CustomerName, SUM(ol.Quantity * ol.UnitPrice) AS Total
FROM Sales.Orders as o
JOIN Sales.OrderLines ol
	ON o.OrderID = ol.OrderID
JOIN Sales.Customers sc
	ON sc.CustomerID = o.CustomerID
GROUP BY o.CustomerID, sc.CustomerName, o.OrderID
ORDER BY Total DESC
GO


-- List top 5 states by number of customers
SELECT TOP 5 sp.StateProvinceName, COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Sales.Customers AS c
JOIN Application.Cities AS ci
	ON c.DeliveryCityID = ci.CityID
JOIN Application.StateProvinces AS sp
	ON ci.StateProvinceID = sp.StateProvinceID

GROUP BY sp.StateProvinceName
ORDER BY CustomerCount DESC
GO




-- Find total revenue generated per year
SELECT YEAR(o.OrderDate) AS OrderYear, SUM(ol.Quantity * ol.UnitPrice) AS TotalRevenue
FROM Sales.Orders AS o
JOIN Sales.OrderLines ol
	ON o.OrderID = ol.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY OrderYear DESC
GO













