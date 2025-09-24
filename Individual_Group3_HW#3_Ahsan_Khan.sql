-- Example 1: Customer names with order IDs and sales person
SELECT
	c.CustomerName,
	o.OrderID,
	sp.FullName AS SalesPerson
FROM
	Sales.Customers AS c
JOIN Sales.Orders AS o ON
	c.CustomerID = o.CustomerID
JOIN Application.People AS sp ON
	o.SalespersonPersonID = sp.PersonID;

-- Example 2: First 10 orders with customer, stock item, and quantity
SELECT
	TOP 10 o.OrderID,
	c.CustomerName,
	si.StockItemName,
	ol.Quantity
FROM
	Sales.Orders AS o
JOIN Sales.OrderLines AS ol ON
	o.OrderID = ol.OrderID
JOIN Warehouse.StockItems AS si ON
	ol.StockItemID = si.StockItemID
JOIN Sales.Customers AS c ON
	o.CustomerID = c.CustomerID;

-- Example 3: Total quantity of each stock item per customer
SELECT
	c.CustomerName,
	si.StockItemName,
	SUM(ol.Quantity) AS TotalQuantity
FROM
	Sales.Customers AS c
JOIN Sales.Orders AS o ON
	c.CustomerID = o.CustomerID
JOIN Sales.OrderLines AS ol ON
	o.OrderID = ol.OrderID
JOIN Warehouse.StockItems AS si ON
	ol.StockItemID = si.StockItemID
GROUP BY
	c.CustomerName,
	si.StockItemName
ORDER BY
	c.CustomerName,
	TotalQuantity DESC;

--Example 4: Top 5 customers by number of orders
SELECT
	TOP 5 c.CustomerName,
	COUNT(o.OrderID) AS OrderCount
FROM
	Sales.Customers AS c
JOIN Sales.Orders AS o
ON
	c.CustomerID = o.CustomerID
GROUP BY
	c.CustomerName
ORDER BY
	OrderCount DESC;

--Example 5: Orders with customer name and delivery city
SELECT
	o.OrderID,
	c.CustomerName
FROM
	Sales.Orders AS o
JOIN Sales.Customers AS c
ON
	o.CustomerID = c.CustomerID;

--Example 6: First 10 invoices with customer and salesperson
SELECT
	TOP 10 i.InvoiceID,
	c.CustomerName,
	sp.FullName AS SalesPerson
FROM
	Sales.Invoices AS i
JOIN Sales.Customers AS c
ON
	i.CustomerID = c.CustomerID
JOIN Application.People AS sp
ON
	i.SalespersonPersonID = sp.PersonID;

--Example 7: Most expensive stock items and their supplier
SELECT
	TOP 5 si.StockItemName,
	si.UnitPrice,
	s.SupplierName
FROM
	Warehouse.StockItems AS si
JOIN Purchasing.Suppliers AS s
ON
	si.SupplierID = s.SupplierID
ORDER BY
	si.UnitPrice DESC;

--Example 8: Employees and number of orders they picked
SELECT
	p.FullName,
	COUNT(o.OrderID) AS OrdersPicked
FROM
	Application.People AS p
JOIN Sales.Orders AS o
ON
	p.PersonID = o.PickedByPersonID
GROUP BY
	p.FullName
ORDER BY
	OrdersPicked DESC;

--Example 9: Top 5 customers by total quantity ordered
SELECT
	TOP 5 c.CustomerName,
	SUM(ol.Quantity) AS TotalQuantity
FROM
	Sales.Customers AS c
JOIN Sales.Orders AS o
ON
	c.CustomerID = o.CustomerID
JOIN Sales.OrderLines AS ol
ON
	o.OrderID = ol.OrderID
GROUP BY
	c.CustomerName
ORDER BY
	TotalQuantity DESC;

--Example 10: Stock items and their category
SELECT
	si.StockItemName,
	sc.StockGroupName
FROM
	Warehouse.StockItems AS si
JOIN Warehouse.StockItemStockGroups AS sig
ON
	si.StockItemID = sig.StockItemID
JOIN Warehouse.StockGroups AS sc
ON
	sig.StockGroupID = sc.StockGroupID;