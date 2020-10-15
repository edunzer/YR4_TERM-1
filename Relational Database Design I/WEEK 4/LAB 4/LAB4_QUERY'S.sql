
-- QUESTION 1

CREATE PROC spInsertCategory
@CategoryName VARCHAR(50)
AS INSERT INTO Categories(CategoryName) VALUES (@CategoryName);
GO
EXEC spInsertCategory 'Guitars';
GO
EXEC spInsertCategory 'New Category';

-- QUESTION 2

CREATE FUNCTION fnDiscountPrice(@ItemID int)
RETURNS DECIMAL

BEGIN
RETURN (SELECT ItemPrice - DiscountAmount AS DiscountPrice
FROM OrderItems
WHERE ItemID = @ItemID)
END


-- QUESTION 3

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