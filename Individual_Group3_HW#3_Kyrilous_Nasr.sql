--  Kyrilous Nasr
--  Assignment #2 (Chapter 3: Joins)

-- List each customer and the orders they have placed
SELECT c.CustomerName AS "Customer Name", COUNT(c.CustomerID) AS "Total Orders"
FROM Sales.Orders AS o
JOIN Sales.Customers AS c
	ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName, c.CustomerID




--Which customers placed an order in 2016 and which salesman was assigned to them.




-- List top 10 most ordered stock items along with their supplier names.





-- List all stock items along with the warehouse that stores them




-- Show all employees along with the cities they work in



-- List all employees along with the total number of sales they have made



-- Find cost of all stock items, using their unit price display profit made from each item.



-- Find the supplier that we have purchased the most stock from (Value wise).



-- Find top 5 largest invoices along with the customer name and salesperson who proccessed it.


-- Find which color item sold the most in the year 2016.

