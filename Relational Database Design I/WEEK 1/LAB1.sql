/*
Write a SELECT statement that returns these columns from the Products table:
The ListPrice column
The DiscountPercent column
A column named DiscountAmount that uses the previous two columns to calculate the discount amount and uses the ROUND function to round the result to 2 decimal places
*/

-- QUESTION 1

SELECT ListPrice, DiscountPercent, ROUND((ListPrice*(DiscountPercent/100)),2) AS DiscountAmount
FROM Products

/*
Write a SELECT statement that returns these columns from the Orders table:
The OrderDate column
A column that returns the four-digit year that’s stored in the OrderDate column
A column that returns only the day of the month that’s stored in the OrderDate column.
A column that returns the result from adding thirty days to the OrderDate column.
*/

-- QUESTION 2

SET DATEFORMAT DMY;
SELECT OrderDate, YEAR(OrderDate) AS OrderYear, DAY(OrderDate) AS OrderDay, DATEADD(DD,30,OrderDate) AS FutureOrderDate
FROM Orders

/*
Write a SELECT statement that returns these columns from the Orders table:
The CardNumber column
The length of the CardNumber column
The last four digits of the CardNumber column
When you get that working right, add the column that follows to the result set. This is more difficult because the column requires the use of functions within functions.

A column that displays the last four digits of the CardNumber column in this format: XXXX-XXXX-XXXX-1234. In other words, use Xs for the first 12 digits of the card number and actual numbers for the last four digits of the number.
*/

-- QUESTION 3

SELECT CardNumber, Len(CardNumber) AS CardLen, RIGHT(CardNumber,4) AS LastFourDigit, CONCAT('XXXX-XXXX-XXXX-',RIGHT(CardNumber,4)) AS FormatedNumber
FROM Orders

/*
Write a SELECT statement that returns these columns from the Orders table:
The OrderID column
The OrderDate column
A column named ApproxShipDate that’s calculated by adding 2 days to the OrderDate column
The ShipDate column
A column named DaysToShip that shows the number of days between the order date and the ship date
When you have this working, add a WHERE clause that retrieves just the orders for March 2012.
*/

-- QUESTION 4

SELECT OrderID, OrderDate, DATEADD(DAY,2,OrderDate) as ApproxShipDate, DATEDIFF(DAY,OrderDate,DATEADD(DAY,2,OrderDate)) as DaysToShip
FROM Orders
WHERE YEAR(OrderDate) = 2012 AND MONTH(OrderDate) = 3
