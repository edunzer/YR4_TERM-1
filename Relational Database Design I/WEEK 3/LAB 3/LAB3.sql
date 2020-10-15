

-- PART 2 ---




-- QUESTION 1

/*
Create a view named CustomerAddresses that shows the shipping and billing addresses for each customer in the MyGuitarShop database.
This view should return these columns from the Customers table: CustomerID, EmailAddress, LastName and FirstName.
This view should return these columns from the Addresses table: BillLine1, BillLine2, BillCity, BillState, BillZip, ShipLine1, ShipLine2, ShipCity, ShipState, and ShipZip.
Use the BillingAddressID and ShippingAddressID columns in the Customers table to determine which addresses are billing addresses and which are shipping addresses.
HINT: You can use two JOIN clauses to join the Addresses table to Customers table twice (once for each type of address).
*/

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

/*
Write a SELECT statement that returns these columns from the CustomerAddresses view that you created in exercise 1: CustomerID, LastName, FirstName, BillLine1.
*/

SELECT CustomerID, LastName, FirstName, BillLine1

FROM CustomerAddresses

-- QUESTION 3

/*
Write an UPDATE statement that updates the CustomerAddresses view you created in exercise 1 so it sets the first line of the shipping address to “1990 Westwood Blvd.” for the customer with an ID of 8.
*/

UPDATE CustomerAddresses

SET BillLine1 = '1990 Westwood Blvd.'
WHERE CustomerID = 8

-- QUESTION 4

/*
Create a view named OrderItemProducts that returns columns from the Orders, OrderItems, and Products tables.
This view should return these columns from the Orders table: OrderID, OrderDate, TaxAmount, and ShipDate.
This view should return these columns from the OrderItems table: ItemPrice, DiscountAmount, FinalPrice (the discount amount subtracted from the item price), Quantity, and ItemTotal (the calculated total for the item).
This view should return the ProductName column from the Products table.
*/

CREATE VIEW OrderItemProducts

AS
SELECT o.OrderID, OrderDate, TaxAmount, ShipDate,
       ProductName, ItemPrice, DiscountAmount, ItemPrice - DiscountAmount AS FinalPrice, Quantity,
       (ItemPrice - DiscountAmount) * Quantity AS ItemTotal
FROM Orders o
    JOIN OrderItems li ON o.OrderID = li.OrderID
    JOIN Products p ON li.ProductID = p.ProductID

-- QUESTION 5

/*
Create a view named ProductSummary that uses the view you created in exercise 4. This view should return some summary information about each product.
Each row should include these columns: ProductName, OrderCount (the number of times the product has been ordered), and OrderTotal (the total sales for the product).
*/

CREATE VIEW ProductSummary

AS
SELECT ProductName, COUNT(ProductName) AS OrderCount, SUM(ItemTotal) AS OrderTotal
FROM OrderItemProducts
GROUP BY ProductName

-- QUESTION 6

/*
Write a SELECT statement that uses the view that you created in exercise 5 to get total sales for the five best selling products.
*/

SELECT TOP 5 ProductName, OrderTotal
FROM ProductSummary
ORDER BY OrderTotal DESC





-- PART 3 --





-- QUESTION 1

/*
Write a script that declares a variable and sets it to the count of all products in the Products table. If the count is greater than or equal to 7, the script should display a message that says, “The number of products is greater than or equal to 7”. Otherwise, it should say, “The number of products is less than 7”.
*/

USE MyGuitarShop;
DECLARE @ProductCount int;
SET @ProductCount = (SELECT COUNT(ProductName)
FROM Products);
IF @ProductCount > 0 PRINT'The number of products is greater than or equal to 7';
ELSE PRINT'The number of products is less than 7';


-- QUESTION 2

/*
Write a script that uses two variables to store (1) the count of all of the products in the Products table and (2) the average list price for those products. If the product count is greater than or equal to 7, the script should print a message that displays the values of both variables. Otherwise, the script should print a message that says, “The number of products is less than 7”.
*/

USE MyGuitarShop;
DECLARE @Product_Count int;
DECLARE @AvgList_Price int;
SET @Product_Count = (SELECT COUNT(ProductName)
FROM Products);
SET @AvgList_Price = (SELECT AVG(ListPrice) FROM Products);
IF @Product_Count>=7 PRINT CONCAT('product count : ', @Product_Count);
ELSE PRINT CONCAT('list price average: ', @AvgList_Price);



-- QUESTION 3

/*
Write a script that calculates the common factors between 10 and 20. To find a common factor, you can use the modulo operator (%) to check whether a number can be evenly divided into both numbers. Then, this script should print lines that display the common factors like this:
Common factors of 10 and 20

1

2

5
*/

USE MyGuitarShop;
DECLARE @COUNTER INT
DECLARE @FACT10 INT
DECLARE @FACT20 INT
DECLARE @FACTORS varchar (100)

SET @FACT10 = 10;
SET @FACT20 = 20;
SET @COUNTER = 1;
SET @FACTORS = 'Factors of 10 and 20: ' + CHAR(13);

WHILE (@COUNTER <= 10/2)
BEGIN
IF ( @FACT10 %  @COUNTER = 0 AND @FACT20 % @COUNTER = 0)
SET @FACTORS = CONCAT (@FACTORS, @COUNTER, ' ', CHAR(13));
SET @COUNTER = @COUNTER + 1;
END
SELECT @FACTORS

-- QUESTION 4

/*
Write a script that attempts to insert a new category named “Guitars” into the Categories table. If the insert is successful, the script should display this message:
SUCCESS: Record was inserted.

If the update is unsuccessful, the script should display a message something like this:

FAILURE: Record was not inserted.

Error 2627: Violation of UNIQUE KEY constraint 'UQ__Categori__8517B2E0A87CE853'. Cannot insert duplicate key in object 'dbo.Categories'. The duplicate key value is (Guitars).
*/

USE MyGuitarShop;
GO
DECLARE @ERR INT = 0;

INSERT INTO Categories
  (CategoryID, CategoryName)
VALUES
  (5, 'Guitars');

SET @ERR = @@ERROR;
IF (@ERR = 0)
BEGIN
PRINT 'SUCCESS: Record was inserted';
END
ELSE IF (@ERR = 2627)
BEGIN
PRINT 'FAILURE: Record was not inserted.';
PRINT 'Error 2627: Violation of UNIQUE KEY constraint ''UQ__Categori__8517B2E0A87CE853''.' ;
PRINT 'Cannot insert duplicate key in object ''dbo.Categories''. The duplicate key value ';
END
ELSE
BEGIN
PRINT 'FAILURE: Record was not inserted.';
PRINT 'Error ' + STR(@ERR, 6, 0) + ' was not gracefully handled';
END
GO
