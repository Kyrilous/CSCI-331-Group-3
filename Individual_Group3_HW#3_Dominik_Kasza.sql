USE WideWorldImporters;
GO
--Dominik Kasza

--1. Finds the top products by quantity sold
SELECT TOP 5
    S.StockItemName,
    SUM(OL.Quantity) AS TotalSold
FROM Sales.OrderLines AS OL
INNER JOIN Warehouse.StockItems AS S ON OL.StockItemID = S.StockItemID
GROUP BY S.StockItemName
ORDER BY TotalSold DESC;

--2. Calculates total orders and total quantity purchased per customer.

SELECT
    C.CustomerID,
    C.CustomerName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OL.Quantity) AS TotalQuantity
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN Sales.OrderLines AS OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalOrders DESC;

--3. Shows which salesperson handled which customer's orders
SELECT
    C.CustomerName,
    E.FullName AS SalesEmployeeName,
    COUNT(O.OrderID) AS OrdersCount
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN Application.People AS E ON O.SalespersonPersonID = E.PersonID
GROUP BY C.CustomerName, E.FullName
ORDER BY SalesEmployeeName, C.CustomerName;

--4. Identifies customers who have never placed an order
SELECT
    C.CustomerID,
    C.CustomerName
FROM Sales.Customers AS C
LEFT JOIN Sales.Orders AS O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

--5. Finds all customers who ordered during a specific time frame.
SELECT DISTINCT
    C.CustomerName,
    O.OrderDate
FROM Sales.Customers AS C
INNER JOIN Sales.Orders AS O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate >= '2015-09-01'
  AND O.OrderDate < '2015-10-01'
ORDER BY C.CustomerName;

--6. Lists every stock item and its associated product group
SELECT
    S.StockItemName,
    G.StockGroupName
FROM Warehouse.StockItems AS S
INNER JOIN Warehouse.StockItemStockGroups AS SG ON S.StockItemID = SG.StockItemID
INNER JOIN Warehouse.StockGroups AS G ON SG.StockGroupID = G.StockGroupID
ORDER BY S.StockItemName;


--7. Shows all products and their primary supplier.
SELECT
    P.StockItemName,
    S.SupplierName
FROM Warehouse.StockItems AS P
LEFT JOIN Purchasing.Suppliers AS S ON P.SupplierID = S.SupplierID
ORDER BY P.StockItemName;

--8. Reports the total quantity on hand for every product in the warehouse.
SELECT
    S.StockItemName,
    SUM(H.QuantityOnHand) AS TotalStock
FROM Warehouse.StockItems AS S
INNER JOIN Warehouse.StockItemHoldings AS H ON S.StockItemID = H.StockItemID
GROUP BY S.StockItemName
ORDER BY TotalStock DESC;

--9. Identifies items that have low stock (less than 30 units)
SELECT
    S.StockItemName,
    H.QuantityOnHand AS CurrentStock
FROM Warehouse.StockItems AS S
INNER JOIN Warehouse.StockItemHoldings AS H ON S.StockItemID = H.StockItemID
WHERE H.QuantityOnHand < 30
ORDER BY CurrentStock;

--10. Provides the full, line-by-line order history for a specific customer
SELECT
    O.OrderID,
    O.OrderDate,
    SI.StockItemName,
    OL.Quantity
FROM Sales.Orders AS O
INNER JOIN Sales.OrderLines AS OL ON O.OrderID = OL.OrderID
INNER JOIN Warehouse.StockItems AS SI ON OL.StockItemID = SI.StockItemID
WHERE O.CustomerID = 4 --desired customer ID
ORDER BY O.OrderDate DESC;

