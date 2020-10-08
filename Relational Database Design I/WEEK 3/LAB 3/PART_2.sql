-- QUESTION 1

CREATE VIEW CustomerAddresses AS
SELECT c.CustomerID, EmailAddress, LastName, FirstName, 
    ba.Line1 AS BillLine1, ba.Line2 AS BillLine2, 
    ba.City AS BillCity, ba.State AS BillState, ba.ZipCode AS BillZip, 
    sa.Line1 AS ShipLine1, sa.Line2 AS ShipLine2, 
    sa.City AS ShipCity, sa.State AS ShipState, sa.ZipCode AS ShipZip 
FROM Customers c 
    JOIN Addresses ba ON c.BillingAddressID  = ba.AddressID
    JOIN Addresses sa ON c.ShippingAddressID = sa.AddressID

-- QUESTION 2

SELECT CustomerID, LastName, FirstName, BillLine1

FROM CustomerAddresses

-- QUESTION 3

UPDATE CustomerAddresses

SET BillLine1 = '1990 Westwood Blvd.'
WHERE CustomerID = 8

-- QUESTION 4

CREATE VIEW OrderItemProducts

AS
SELECT o.OrderID, OrderDate, TaxAmount, ShipDate, 
       ProductName, ItemPrice, DiscountAmount, ItemPrice - DiscountAmount AS FinalPrice, Quantity, 
       (ItemPrice - DiscountAmount) * Quantity AS ItemTotal       
FROM Orders o
    JOIN OrderItems li ON o.OrderID = li.OrderID
    JOIN Products p ON li.ProductID = p.ProductID

-- QUESTION 5

CREATE VIEW ProductSummary

AS
SELECT ProductName, COUNT(ProductName) AS OrderCount, SUM(ItemTotal) AS OrderTotal
FROM OrderItemProducts
GROUP BY ProductName

-- QUESTION 6

SELECT TOP 5 ProductName, OrderTotal
FROM ProductSummary 
ORDER BY OrderTotal DESC