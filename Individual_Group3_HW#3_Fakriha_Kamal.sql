USE WideWorldImporters;
GO

/*1 for each customer return the total number of orders they placed
and total quantity of products they ordered*/
SELECT 
    C.CustomerID,                                      -- customer id
    C.CustomerName,                                    -- customer name
    COUNT(DISTINCT O.OrderID) AS TotalOrders,          -- count distinct number of orders per customer
    SUM(OL.PickedQuantity) AS TotalQuantity            -- sum the total quantity of products ordered per customer
FROM Sales.Customers AS C                              -- starts at cutomer table alias C
INNER JOIN Sales.Orders AS O                           -- joins order table alias O
    ON C.CustomerID = O.CustomerID                     -- matching customers with their orders
INNER JOIN Sales.OrderLines AS OL                      -- joins to order lines table alias OL
    ON O.OrderID = OL.OrderID                          -- matching orders with quantity of item per order
GROUP BY C.CustomerID, C.CustomerName                  -- Group the results by customer to aggregate orders and quantities
ORDER BY TotalOrders DESC;                             -- sort by number of orders

/*2 return customers who placed no orders*/
SELECT 
    C.CustomerID,                                      -- customer ID
    C.CustomerName,                                    -- customer name
    O.OrderID                                          -- order ID (will be NULL if no orders exist)
FROM Sales.Customers AS C                              -- start from Customers table
LEFT JOIN Sales.Orders AS O                            -- left join to Orders (so customers with no orders still show up)
    ON C.CustomerID = O.CustomerID                     -- match customer to orders
WHERE O.OrderID IS NULL;                               -- filter to only customers who have no matching orders

/*3 return customers who placed orders in September,2015*/
SELECT DISTINCT                                        -- DISTINCT so no duplicate rows
    C.CustomerID,                                      -- customer ID
    C.CustomerName,                                    -- customer name
    O.OrderDate                                        -- order date
FROM Sales.Customers AS C                              -- start with Customers table
INNER JOIN Sales.Orders AS O                           -- join with Orders table
    ON C.CustomerID = O.CustomerID                     -- match customers with their orders
WHERE O.OrderDate >= '2015-09-01'                      -- only orders starting September 1, 2015
  AND O.OrderDate < '2015-10-01';                      -- and before October 1, 2015

/*4 return customers who have ordered fom the same employee*/
SELECT 
    C.CustomerID,                                      -- customer ID
    C.CustomerName,                                    -- customer name
    O.SalespersonPersonID AS SalesEmployeeID           -- which salesperson handled the order
FROM Sales.Customers AS C                              -- start from Customers table
INNER JOIN Sales.Orders AS O                           -- join with Orders table
    ON C.CustomerID = O.CustomerID                     -- match customer to orders
ORDER BY O.SalespersonPersonID, C.CustomerName;        -- sort by employee, then by customer

/*5 categorization of all the products*/
SELECT 
    S.StockItemID,                                     -- product ID
    S.StockItemName,                                   -- product name
    C.StockGroupName                                   -- category/group name
FROM Warehouse.StockItems AS S                         -- start from StockItems table
INNER JOIN Warehouse.StockItemStockGroups AS SG        -- join link table between items and groups
    ON S.StockItemID = SG.StockItemID                  -- match product to the link
INNER JOIN Warehouse.StockGroups AS C                  -- join StockGroups table
    ON SG.StockGroupID = C.StockGroupID;               -- match group to the link

/*6 inventory how many stock there is of each item*/
SELECT 
    S.StockItemID,                                     -- product ID
    S.StockItemName,                                   -- product name
    SUM(W.QuantityOnHand) AS TotalStock                -- sum up total stock available for each item
FROM Warehouse.StockItems AS S                         -- start from StockItems table
INNER JOIN Warehouse.StockItemHoldings AS W            -- join holdings table (stock levels)
    ON S.StockItemID = W.StockItemID                   -- match items with stock quantities
GROUP BY S.StockItemID, S.StockItemName;               -- group by product to calculate stock totals


/*7 list 5 most selling product*/
SELECT TOP 5                                           -- return only the top 5 rows
    OL.StockItemID,                                    -- product ID
    S.StockItemName,                                   -- product name
    SUM(OL.Quantity) AS TotalSold                      -- total quantity sold per product
FROM Sales.OrderLines AS OL                            -- start from OrderLines table
INNER JOIN Warehouse.StockItems AS S                   -- join StockItems table
    ON OL.StockItemID = S.StockItemID                  -- match product ID
GROUP BY OL.StockItemID, S.StockItemName               -- group by product
ORDER BY TotalSold DESC;                               -- sort by most sold first

/*8 Show all products and their suppliers*/
SELECT 
    P.StockItemName,                                   -- product name
    S.SupplierName                                     -- supplier name
FROM Warehouse.StockItems AS P                         -- start from StockItems table
FULL OUTER JOIN Purchasing.Suppliers AS S              -- full outer join ensures all products and all suppliers are shown
    ON P.SupplierID = S.SupplierID;                    -- match product supplier with suppliers table

/*9 show which items need to restocked*/
SELECT 
    S.StockItemID,                                     -- product ID
    S.StockItemName,                                   -- product name
    H.QuantityOnHand                                   -- quantity available in stock
FROM Warehouse.StockItems AS S                         -- start from StockItems table
INNER JOIN Warehouse.StockItemHoldings AS H            -- join StockItemHoldings table (inventory levels)
    ON S.StockItemID = H.StockItemID                   -- match items with their stock holdings
WHERE H.QuantityOnHand < 30;                           -- filter: items below threshold (30 units)

/*10 according to customer id, show his order history, 
(all the orders, date of purchase, due date, quantity purchased)*/
SELECT 
    O.CustomerID,                                      -- customer ID
    O.OrderID,                                         -- order ID
    O.OrderDate,                                       -- date of purchase
    O.ExpectedDeliveryDate AS DueDate,                 -- expected delivery/due date
    OL.StockItemID,                                    -- product ID in the order
    OL.Quantity                                        -- how many units purchased
FROM Sales.Orders AS O                                 -- start from Orders table
INNER JOIN Sales.OrderLines AS OL                      -- join OrderLines table
    ON O.OrderID = OL.OrderID                          -- match orders with their order lines
WHERE O.CustomerID = 1                                 -- filter for a specific customer (example: customer 1)
ORDER BY O.OrderDate DESC;                             -- sort most recent orders first


