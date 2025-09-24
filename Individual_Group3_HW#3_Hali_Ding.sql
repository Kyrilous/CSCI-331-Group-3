-- 1. Show number of cities 
SELECT 
    CASE 
        WHEN LatestRecordedPopulation IS NULL THEN N'NONE'
        WHEN LatestRecordedPopulation < 100000 THEN N'Small'
        WHEN LatestRecordedPopulation < 1000000 THEN N'Medium'
        ELSE N'Large'
    END AS CitiSize,
    COUNT(*) AS NumOfCities,
    AVG(LatestRecordedPopulation) AS AvgPopulation
FROM Application.Cities
GROUP BY 
    CASE 
        WHEN LatestRecordedPopulation IS NULL THEN N'NONE'
        WHEN LatestRecordedPopulation < 100000 THEN N'Small'
        WHEN LatestRecordedPopulation < 1000000 THEN N'Medium'
        ELSE N'Large'
    END
ORDER BY NumOfCities DESC;


-- 2. Get sum of countries in each subregion, and get their average population
SELECT
	Region,
	Subregion,
	COUNT(*) AS NumOfCountries,
	AVG(LatestRecordedPopulation) AS AvgPopulation
FROM
	Application.Countries
GROUP BY
	Region,
	Subregion
ORDER BY
	NumOfCountries DESC,
	Region,
	Subregion;


-- 3. Show the total amount of supplier transactions per month
SELECT
	YEAR(TransactionDate) AS Year,
	MONTH(TransactionDate) AS Month,
	SUM(AmountExcludingTax) AS BeforeTax,
	SUM(AmountExcludingTax + TaxAmount) AS AfterTax
FROM
	Purchasing.SupplierTransactions
WHERE
	TransactionDate IS NOT NULL
GROUP BY
	YEAR(TransactionDate),
	MONTH(TransactionDate)
ORDER BY
	Year DESC,
	Month DESC;


-- 4. Show orders per year
SELECT
	YEAR(OrderDate) AS OrderYear,
	COUNT(*) AS NumOrders
FROM
	Purchasing.PurchaseOrders
WHERE
	OrderDate IS NOT NULL
GROUP BY
	YEAR(OrderDate)
ORDER BY
	OrderYear DESC;


-- 5. Show daily orders in 2015
SELECT
	CAST(OrderDate AS date) AS OrderDay,
	COUNT(*) AS OrderPlaced
FROM
	Sales.Orders
WHERE
	OrderDate > '2014-12-31'
	AND OrderDate < '2016-01-01'
GROUP BY
	CAST(OrderDate AS date)
ORDER BY
	OrderDay;


-- 6. Shows the status of inventory
SELECT
	StockItemStatus,
	COUNT(*) AS NumItems
FROM
	(
	SELECT
		CASE
			WHEN QuantityOnHand IS NULL THEN N'Unknown'
			WHEN QuantityOnHand = 0 THEN N'Out of Stock'
			WHEN QuantityOnHand < ReorderLevel THEN N'Below Reorder'
			WHEN QuantityOnHand <= TargetStockLevel THEN N'OK'
			ELSE N'Over Target'
		END AS StockItemStatus
	FROM
		Warehouse.StockItemHoldings
) AS s
GROUP BY
	StockItemStatus
ORDER BY
	StockItemStatus;


-- 7. Show the top 20 item that's best selling with their average price
SELECT
	TOP (20)
    StockItemID,
	SUM(Quantity) AS TotalQuantity,
	CAST(AVG(UnitPrice) AS decimal(10, 2)) AS AvgUnitPrice
FROM
	Sales.OrderLines
GROUP BY
	StockItemID
HAVING
	SUM(Quantity) >= 1000
ORDER BY
	TotalQuantity DESC,
	StockItemID;


-- 8. for each day in 2016, show how many stock transactions had and the total quantity of stock items transacted
SELECT
	CAST(TransactionOccurredWhen AS date) AS TransactionDay,
	COUNT(*) AS NumOfTransaction,
	SUM(Quantity) AS TotalQuantity
FROM
	Warehouse.StockItemTransactions
WHERE
	TransactionOccurredWhen >= '2016-01-01'
	AND TransactionOccurredWhen < '2017-01-01'
GROUP BY
	CAST(TransactionOccurredWhen AS date)
ORDER BY
	TransactionDay;


-- 9. Show the cold room temperature min/avg/max as each month in 2016
SELECT
	YEAR(RecordedWhen) AS Year,
	MONTH(RecordedWhen) AS Month,
	MIN(Temperature) AS MinTemp,
	MAX(Temperature) AS MaxTemp,
	AVG(Temperature) AS AvgTemp
FROM
	Warehouse.ColdRoomTemperatures_Archive
WHERE
	RecordedWhen >= '2016-01-01'
	AND RecordedWhen < '2017-01-01'
GROUP BY
	YEAR(RecordedWhen),
	MONTH(RecordedWhen)
ORDER BY
	Year,
	Month;


-- 10. number of orders by sales person by month in year 2016
SELECT
	SalespersonPersonID,
	YEAR(OrderDate) AS Year,
	MONTH(OrderDate) AS Month,
	COUNT(*) AS NumOrders
FROM
	Sales.Orders
WHERE
	OrderDate >= '2016-01-01'
	AND OrderDate < '2017-01-01'
	AND SalespersonPersonID IS NOT NULL
GROUP BY
	SalespersonPersonID,
	YEAR(OrderDate),
	MONTH(OrderDate)
ORDER BY
	NumOrders DESC,
	SalespersonPersonID,
	Year,
	Month;