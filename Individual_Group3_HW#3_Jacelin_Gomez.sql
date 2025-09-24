
--Proposition 1: Find customers without orders
--Purpose: Finds customers with no matching orders, useful for spotting inactive customers.
SELECT C.CustomerID, C.CustomerName
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
	ON O.CustomerID = C.CustomerID
WHERE O.OrderID IS NULL
ORDER BY C.CustomerID;
--Output: There are no results because (in the current dataset) all customers have placed orders.


--Proposition 2: Rank customers by how many orders they’ve placed
--Purpose: Find out how many orders each customer has placed, including those who have placed none, 
-- 			and then rank the customers by their order count (highest to lowest).
SELECT C.CustomerID, C.CustomerName, COUNT(O.OrderID) AS num_orders
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
	ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY num_orders DESC, C.CustomerName;


--Proposition 3: Top 5 products by total quantity ordered
--Purpose: Identifies best-selling items, by total quantity sold, including any ties at 5th place.
SELECT TOP (5) WITH TIES SI.StockItemID, SI.StockItemName, SUM(OL.Quantity) AS total_qty
FROM Sales.OrderLines AS OL
JOIN Warehouse.StockItems AS SI
	ON SI.StockItemID = OL.StockItemID
GROUP BY SI.StockItemID, SI.StockItemName
ORDER BY total_qty DESC;


--Proposition 4: Orders per salesperson (include employees w/ zero)
--Purpose: Compares workload across employees, showing who handled many vs. none
SELECT P.PersonID, P.FullName, COUNT(O.OrderID) AS num_orders
FROM Application.People AS P
LEFT OUTER JOIN Sales.Orders AS O
	ON O.SalespersonPersonID = P.PersonID
GROUP BY P.PersonID, P.FullName
ORDER BY num_orders DESC, P.FullName;


--Proposition 5: Orders placed in 2016 w/ customer details
--Purpose: Retrieves all orders from 2016 with customer details, useful for yearly sales reporting.
SELECT O.OrderID, O.OrderDate, C.CustomerName, C.CustomerID
FROM Sales.Orders AS O
JOIN Sales.Customers AS C
	ON C.CustomerID = O.CustomerID
WHERE O.OrderDate >= '2016-01-01' AND O.OrderDate < '2017-01-01'
ORDER BY O.OrderDate, O.OrderID;


--Proposition 6: Show each customer and the category that customer belongs to
--Purpose: Useful for seeing what type of customer each one is (like Retail, Wholesale, etc.), 
-- 			which helps check id data is correct and/or when analyzing sales.
SELECT Cust.CustomerName, Cat.CustomerCategoryName
FROM Sales.Customers AS Cust
JOIN Sales.CustomerCategories AS Cat
	ON Cust.CustomerCategoryID = Cat.CustomerCategoryID
ORDER BY Cust.CustomerName ASC;


--Proposition 7: Customers with a primary contact and with or without alternate contacts
--Purpose: Useful for quickly seeing who the main and backup contacts are for each customer. This helps sales or support teams
--			know the right people to reach out to, and ensures every customer has proper contact info recorded.
SELECT C.CustomerName, P.FullName AS PrimaryContact, alt.FullName AS AlternateContact 
FROM Sales.Customers AS C
JOIN Application.People AS P
	ON C.PrimaryContactPersonID = P.PersonID
LEFT JOIN Application.People AS alt 
	ON C.AlternateContactPersonID = alt.PersonID;


--Proposition 8: Detailed order history with customers and products
--Purpose: Brings together customer, order, line, and product data for full sales detail
SELECT C.CustomerID, C.CustomerName, O.OrderID, O.OrderDate, OL.OrderLineID, SI.StockItemID, SI.StockItemName, OL.Quantity, OL.UnitPrice
FROM Sales.Customers AS C
JOIN Sales.Orders AS O  
	ON O.CustomerID = C.CustomerID
JOIN Sales.OrderLines AS OL 
	ON OL.OrderID = O.OrderID
JOIN Warehouse.StockItems AS SI 
	ON SI.StockItemID = OL.StockItemID
ORDER BY O.OrderDate, O.OrderID, OL.OrderLineID;


--Proposition 9: Supplier products and their total sales quantities
--Purpose: Shows supplier performance, including suppliers with unsold products.
SELECT S.SupplierID, S.SupplierName, SI.StockItemID, SI.StockItemName, SUM(OL.Quantity) AS total_qty_sold
FROM Purchasing.Suppliers AS S
LEFT OUTER JOIN Warehouse.StockItems AS SI
	ON SI.SupplierID = S.SupplierID
LEFT OUTER JOIN Sales.OrderLines AS OL
	ON OL.StockItemID = SI.StockItemID
GROUP BY S.SupplierID, S.SupplierName, SI.StockItemID, SI.StockItemName
ORDER BY total_qty_sold DESC;  


--Proposition 10: Number of customers by state/province
--Purpose: Useful for showing how many unique customers are located in each state/province.
SELECT SP.StateProvinceID, SP.StateProvinceName, COUNT(DISTINCT C.CustomerID) AS num_customers
FROM Application.StateProvinces AS SP
LEFT OUTER JOIN Application.Cities AS CT
	ON CT.StateProvinceID = SP.StateProvinceID
LEFT OUTER JOIN Sales.Customers AS C
	ON C.DeliveryCityID = CT.CityID
GROUP BY SP.StateProvinceID, SP.StateProvinceName
ORDER BY SP.StateProvinceName;
