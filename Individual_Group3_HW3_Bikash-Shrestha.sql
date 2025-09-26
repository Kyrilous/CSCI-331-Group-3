--Show total sales amount per customer.
SELECT 
W.Customer, SUM(S.[Total Including Tax]) AS TotalSales
FROM 
WideWorldImportersDW.Dimension.Customer AS W
INNER JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[Customer Key] = S.[Customer Key]
GROUP BY
W.Customer;

--Show total quantity sold per city.
SELECT
W.City, SUM(S.[Total Including Tax]) As TotalSales
FROM
WideWorldImportersDW.Dimension.City AS W
JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[City Key] = S.[City Key]
GROUP BY
W.City;

--Find the Total products sold in year.
SELECT 
W.[Fiscal Year], SUM(S.[Total Including Tax]) AS Total
FROM
WideWorldImportersDW.Dimension.Date as W
LEFT JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[Calendar Year]= YEAR(S.[Invoice Date Key])
GROUP BY
W.[Fiscal Year]
ORDER BY 
[Fiscal Year]

--Show total tax collected per month.

SELECT
    W.[Calendar Month Label],
    YEAR(W.[Date]) AS Year,
    MONTH(W.[Date]) AS Month,
    SUM(S.[Tax Amount]) AS Totaltax
FROM
    WideWorldImportersDW.Dimension.Date AS W
LEFT JOIN
    WideWorldImportersDW.Fact.Sale AS S
ON MONTH(W.[Calendar Year]) = MONTH(S.[Invoice Date Key])
GROUP BY 
    W.[Calendar Month Label], YEAR(W.[Date]), MONTH(W.[Date])
ORDER BY 
    YEAR(W.[Date]), MONTH(W.[Date]);

--Find the customer with the 10 highest total purchase.
SELECT TOP 10
W.Customer, SUM(S.[Total Including Tax]) AS TotalSales
FROM 
WideWorldImportersDW.Dimension.Customer AS W
INNER JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[Customer Key] = S.[Customer Key]
GROUP BY
W.Customer
ORDER BY
TotalSales Desc;


--Find the customer with the 10 low total purchase.
SELECT TOP 10
W.Customer, SUM(S.[Total Including Tax]) AS TotalSales
FROM 
WideWorldImportersDW.Dimension.Customer AS W
INNER JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[Customer Key] = S.[Customer Key]
GROUP BY
W.Customer
ORDER BY
TotalSales;

--Show last 10 cities by total sales amount.
SELECT TOP 10
W.City, SUM(S.[Total Including Tax]) AS TotalSales
FROM
WideWorldImportersDW.Dimension.City AS W
JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[City Key] = S.[City Key]
GROUP BY
W.City
ORDER BY
TotalSales;

--Show Top 10 cities by total sales amount.
SELECT TOP 10
W.City, SUM(S.[Total Including Tax]) AS TotalSales
FROM
WideWorldImportersDW.Dimension.City AS W
JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[City Key] = S.[City Key]
GROUP BY
W.City
ORDER BY
TotalSales desc;

--Find customers who made purchases in more than one city.
SELECT
W.Customer, C.City
FROM
WideWorldImportersDW.Dimension.Customer AS W
INNER JOIN
WideWorldImportersDW.Fact.Sale as S
ON W.[Customer Key]= S.[Customer Key]
INNER JOIN
WideWorldImportersDW.Dimension.City AS C
ON S.[City Key]= C.[City Key]
GROUP BY
W.Customer, C.City
HAVING
COUNT(S.[City Key])>1
ORDER BY
W.Customer;


-- Best Seller
SELECT
S.Employee, SUM(T.[Total Including Tax]) AS TotalSales
FROM
WideWorldImportersDW.Dimension.Employee AS S
INNER JOIN
WideWorldImportersDW.Fact.Sale as T
ON S.[Employee Key]= T.[Salesperson Key]
GROUP BY 
S.Employee
ORDER BY
TotalSales desc;

-- Wrost Seller
SELECT
S.Employee, SUM(T.[Total Including Tax]) AS TotalSales
FROM
WideWorldImportersDW.Dimension.Employee AS S
INNER JOIN
WideWorldImportersDW.Fact.Sale as T
ON S.[Employee Key]= T.[Salesperson Key]
GROUP BY 
S.Employee
ORDER BY
TotalSales;

--Hot Item and Stock
SELECT
B.[Stock Item], B.[Quantity Per Outer] AS Stock, SUM(S.[Quantity]) AS Sold
FROM
WideWorldImportersDW.Dimension.[Stock Item] AS B
INNER JOIN
WideWorldImportersDW.Fact.Sale as S
ON B.[Stock Item Key]= S.[Stock Item Key]
WHERE YEAR(S.[Invoice Date Key])=
(
        SELECT MAX(YEAR([Invoice Date Key]))
        FROM WideWorldImportersDW.Fact.Sale
        )

GROUP BY
B.[Stock Item], B.[Quantity Per Outer]
ORDER BY
Sold desc;
