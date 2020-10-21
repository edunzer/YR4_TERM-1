-- QUESTION 1

/*
Write a script that creates a cursor for a result set that consists of the ProductName and ListPrice columns for each product with a list price that’s greater than $700. The rows in this result set should be sorted in descending sequence by list price. Then, the script should print the product name and list price for each product so it looks something like this:
*/

DECLARE
@ProductName VARCHAR(MAX),
@ListPrice DECIMAL;

DECLARE InvoiceCursor CURSOR
FOR

SELECT ProductName, ListPrice
FROM Products
WHERE ListPrice > 700
ORDER BY ListPrice DESC;

OPEN InvoiceCursor;

FETCH NEXT FROM InvoiceCursor INTO @ProductName, @ListPrice;

WHILE @@FETCH_STATUS = 0
BEGIN

PRINT @ProductName + ', ' + '$' + CAST(@ListPrice AS varchar);
FETCH NEXT FROM InvoiceCursor INTO @ProductName, @ListPrice;

END;

CLOSE InvoiceCursor;
DEALLOCATE InvoiceCursor;



-- QUESTION 2
/*
Write a script to declare and use a cursor for the following SELECT statement. Use a WHILE loop to fetch each row in the result set. Omit the INTO clause to fetch directly to the Results tab.
SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg

FROM Customers JOIN Orders

    ON Customers.CustomerID = Orders.CustomerID

GROUP BY LastName;
*/

DECLARE
@LastName VARCHAR(MAX),
@AvgShipAmount DECIMAL;

DECLARE CustomerShippingCost CURSOR
FOR

SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;

OPEN CustomerShippingCost;

FETCH NEXT FROM CustomerShippingCost

WHILE @@FETCH_STATUS = 0
BEGIN

FETCH NEXT FROM CustomerShippingCost
END;

CLOSE CustomerShippingCost;
DEALLOCATE CustomerShippingCost;



-- QUESTION 3

/*
Modify the solution to exercise 2 to fetch each row into a set of local variables. Use the PRINT statement to return each row in the format “Name, $0.00” to the Messages tab.
*/

DECLARE
@LastName VARCHAR(MAX),
@AvgShipAmount DECIMAL;

DECLARE CustomerShippingCost CURSOR
FOR

SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;

OPEN CustomerShippingCost;

FETCH NEXT FROM CustomerShippingCost INTO @LastName, @AvgShipAmount;

WHILE @@FETCH_STATUS = 0
BEGIN

PRINT @LastName + ',  $' + CAST(@AvgShipAmount AS varchar);
FETCH NEXT FROM CustomerShippingCost INTO @LastName, @AvgShipAmount;

END;

CLOSE CustomerShippingCost;
DEALLOCATE CustomerShippingCost;
