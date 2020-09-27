SELECT OrderID, OrderDate, DATEADD(DAY,2,OrderDate) as ApproxShipDate, DATEDIFF(DAY,OrderDate,DATEADD(DAY,2,OrderDate)) as DaysToShip
FROM Orders
WHERE YEAR(OrderDate) = 2012 AND MONTH(OrderDate) = 3