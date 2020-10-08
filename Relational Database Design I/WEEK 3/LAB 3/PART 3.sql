-- QUESTION 1

USE MyGuitarShop;
DECLARE @ProductCount int;
SET @ProductCount = (SELECT COUNT(ProductName)
FROM Products);
IF @ProductCount > 0 PRINT'The number of products is greater than or equal to 7';
ELSE PRINT'The number of products is less than 7';


-- QUESTION 2


USE MyGuitarShop;
DECLARE @Product_Count int;
DECLARE @AvgList_Price int;
SET @Product_Count = (SELECT COUNT(ProductName)
FROM Products);
SET @AvgList_Price = (SELECT AVG(ListPrice) FROM Products);
IF @Product_Count>=7 PRINT CONCAT('product count : ', @Product_Count);
ELSE PRINT CONCAT('list price average: ', @AvgList_Price);



-- QUESTION 3


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