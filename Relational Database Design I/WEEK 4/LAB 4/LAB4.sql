
-- QUESTION 1

/*
Write a script that creates and calls a stored procedure named spInsertCategory. First, code a statement that creates a procedure that adds a new row to the Categories table. To do that, this procedure should have one parameter for the category name.
Code at least two EXEC statements that test this procedure. (Note that this table doesn’t allow duplicate category names.)
*/

CREATE PROC spInsertCategory
@CategoryName VARCHAR(50)
AS INSERT INTO Categories(CategoryName) VALUES (@CategoryName);
GO
EXEC spInsertCategory 'Guitars';
GO
EXEC spInsertCategory 'New Category';

-- QUESTION 2

/*
Write a script that creates and calls a function named fnDiscountPrice that calculates the discount price of an item in the OrderItems table (discount amount subtracted from item price). To do that, this function should accept one parameter for the item ID, and it should return the value of the discount price for that item.
*/

CREATE FUNCTION fnDiscountPrice(@ItemID int)
RETURNS DECIMAL

BEGIN
RETURN (SELECT ItemPrice - DiscountAmount AS DiscountPrice
FROM OrderItems
WHERE ItemID = @ItemID)
END


-- QUESTION 3

/*
Write a script that creates and calls a function named fnItemTotal that calculates the total amount of an item in the OrderItems table (discount price multiplied by quantity). To do that, this function should accept one parameter for the item ID, it should use the DiscountPrice function that you created in exercise 2, and it should return the value of the total for that item.
*/

CREATE FUNCTION fnItemTotal(@ItemID int)
RETURNS money
BEGIN
RETURN (SELECT dbo.fnDiscountPrice(@ItemId) *
(SELECT Quantity
FROM OrderItems
WHERE ItemID = @ItemID
))
END;

-- QUESTION 4

/*
Write a script that creates and calls a stored procedure named spInsertProduct that inserts a row into the Products table. This stored procedure should accept five parameters. One parameter for each of these columns: CategoryID, ProductCode, ProductName, ListPrice, and DiscountPercent.

This stored procedure should set the Description column to an empty string, and it should set the DateAdded column to the current date.
If the value for the ListPrice column is a negative number, the stored procedure should raise an error that indicates that this column doesn’t accept negative numbers. Similarly, the procedure should raise an error if the value for the DiscountPercent column is a negative number.

Code at least two EXEC statements that test this procedure.
*/

CREATE PROC spInsertProduct
@InCategoryID INT,
@InProductCode VARCHAR,
@InProductName VARCHAR,
@InListPrice INT,
@InDiscountPercent INT

AS

BEGIN
IF @InListPrice < 0 THROW -10000, 'We do not accept negative List Price.', 1;
IF @InDiscountPercent < 0 THROW -10000, 'We do not accept negative Discount Percent.', 1;

INSERT INTO PRODUCTS (CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, Description, DateAdded)
VALUES (@InCategoryID, @InProductCode, @InProductName, @InListPrice, @InDiscountPercent, NULL, GETDATE());
END;

Script:
EXEC spInsertProduct 1, 'A', 'Nike Air Jordans', 100, .20;
EXEC spInsertProduct 1, 'A', 'Nike Air Jordans', -100, .20;
EXEC spInsertProduct 1, 'A', 'Nike Air Jordans', 100, -.20;

-- QUESTION 5

/*
Write a script that creates and calls a stored procedure named spUpdateProductDiscount that updates the DiscountPercent column in the Products table. This procedure should have one parameter for the product ID and another for the discount percent.
If the value for the DiscountPercent column is a negative number, the stored procedure should raise an error that indicates that the value for this column must be a positive number.

Code at least two EXEC statements that test this procedure.
*/

IF EXISTS (SELECT DB_ID('spUpdateProductDiscount')) DROP PROC spUpdateProductDiscount;
GO

CREATE PROC spUpdateProductDiscount
@ProductID INT,
@DiscountPercent MONEY

AS

IF @DiscountPercent < 0 THROW 50001, 'The discount percent must be a positive number.', 1;

UPDATE products
SET DiscountPercent = @DiscountPercent
WHERE ProductID = @ProductID;

GO
EXEC spUpdateProductDiscount 1, -30;
GO
EXEC spUpdateProductDiscount 1, 30;
GO

-- QUESTION 6

/*
Create a trigger named Products_UPDATE that checks the new value for the DiscountPercent column of the Products table. This trigger should raise an appropriate error if the discount percent is greater than 100 or less than 0.
If the new discount percent is between 0 and 1, this trigger should modify the new discount percent by multiplying it by 100. That way, a discount percent of .2 becomes 20.

Test this trigger with an appropriate UPDATE statement.
*/

CREATE TRIGGER Products_UPDATE
ON Products
AFTER UPDATE

AS

BEGIN
DECLARE @DiscountPercent DECIMAL(9,2)
DECLARE @ProductID INT

SELECT @ProductID = ProductID, @DiscountPercent = DiscountPercent
FROM Products

IF (@DiscountPercent) > 0 AND (@DiscountPercent) < 1
UPDATE Products SET DiscountPercent = @DiscountPercent * 100 WHERE ProductID = @ProductID

IF (@DiscountPercent < 0 OR @DiscountPercent > 100)
BEGIN
ROLLBACK TRAN
RAISEERROR PRINT 'DiscountPercent must be greater than 0 and less than equal to 100', 1
END

END


-- QUESTION 7

/*
Create a trigger named Products_INSERT that inserts the current date for the DateAdded column of the Products table if the value for that column is null.
Test this trigger with an appropriate INSERT statement.
*/

IF EXISTS (SELECT DB_ID('Products_INSERT')) DROP TRIGGER Products_INSERT;
GO

CREATE TRIGGER Products_INSERT
ON Products
AFTER INSERT
AS
UPDATE Products
SET DateAdded = GETDATE()
WHERE ProductID = (SELECT ProductID FROM inserted);

GO

INSERT INTO products
  (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent)
VALUES
  (1, 'TEST', 'TEST', '', 999.99, 27);


-- QUESTION 8

/*
Create a table named ProductsAudit. This table should have all columns of the Products table, except the Description column. Also, it should have an AuditID column for its primary key, and the DateAdded column should be changed to DateUpdated.
Create a trigger named Products_UPDATE. This trigger should insert the old data about the product into the ProductsAudit table after the row is updated. Then, test this trigger with an appropriate UPDATE statement.
*/

IF EXISTS (SELECT DB_ID('ProductsAudit'))
  DROP Table ProductsAudit;
GO

CREATE TABLE ProductsAudit (
AuditID INT PRIMARY KEY IDENTITY,
ProductID INT NOT NULL,
CategoryID INT NOT NULL,
ProductCode VARCHAR(10) NOT NULL,
ProductName VARCHAR(255) NOT NULL,
ListPrice MONEY NOT NULL,
DiscountPercent MONEY NOT NULL DEFAULT 0.00,
DateUpdated DATETIME DEFAULT NULL
);
GO

IF EXISTS (SELECT DB_ID('Products_UPDATE_AUDIT')) DROP TRIGGER Products_UPDATE_AUDIT;
GO

CREATE TRIGGER Products_UPDATE_AUDIT
ON Products
AFTER UPDATE

AS
INSERT INTO ProductsAudit(ProductID, CategoryID,ProductCode, ProductName, ListPrice, DiscountPercent, DateUpdated)
VALUES(
(SELECT ProductID FROM deleted),
(SELECT CategoryID FROM deleted),
(SELECT ProductCode FROM deleted),
(SELECT ProductName FROM deleted),
(SELECT ListPrice FROM deleted),
(SELECT DiscountPercent FROM deleted),
GETDATE());

GO

UPDATE Products
SET ListPrice = 749.00
WHERE ProductID = 1;
