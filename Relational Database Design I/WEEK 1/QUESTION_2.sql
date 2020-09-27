SET DATEFORMAT DMY;
SELECT OrderDate, YEAR(OrderDate) AS OrderYear, DAY(OrderDate) AS OrderDay, DATEADD(DD,30,OrderDate) AS FutureOrderDate
FROM Orders