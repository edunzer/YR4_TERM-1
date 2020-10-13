-- PART 1

USE AP;

GO

CREATE PROC spBalanceRange
@VendorVar varchar(50) = '%',
@BalanceMin money = 0,
@BalanceMax money = 0

AS

IF @BalanceMax = 0
BEGIN
SELECT VendorName, InvoiceNumber, InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Vendors JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE VendorName LIKE @VendorVar AND (InvoiceTotal - CreditTotal - PaymentTotal) > 0 AND (InvoiceTotal - CreditTotal - PaymentTotal) >= @BalanceMin
ORDER BY Balance DESC;
END;

ELSE
BEGIN
SELECT VendorName, InvoiceNumber, InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Vendors JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE VendorName LIKE @VendorVar AND (InvoiceTotal - CreditTotal - PaymentTotal) > 0 AND (InvoiceTotal - CreditTotal - PaymentTotal) BETWEEN @BalanceMin AND @BalanceMax
ORDER BY Balance DESC;
END;

-- PART 2

EXEC spBalanceRange 'M%';

-- PART 3

EXEC spBalanceRange @BalanceMin = 200, @BalanceMax = 1000;

-- PART 4

EXEC spBalanceRange '[C,F]%', 0, 200;

-- PART 5

GO 

CREATE PROC spDateRange
@DateMin varchar(50) = NULL,
@DateMax varchar(50) = NULL

AS

IF @DateMin IS NULL OR @DateMax IS NULL THROW 50001, 'The DateMin and DateMax parameters are required.', 1;
IF NOT (ISDATE(@DateMin) = 1 AND ISDATE(@DateMax) = 1) THROW 50001, 'The date format is not valid. Please use mm/dd/yy.', 1;
IF CAST(@DateMin AS datetime) > CAST(@DateMax AS datetime) THROW 50001, 'The DateMin parametter must be earlier than DateMax.', 1;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Invoices
WHERE InvoiceDate BETWEEN @DateMin AND @DateMax
ORDER BY InvoiceDate;

-- PART 6

BEGIN TRY
EXEC spDateRange '2011-12-10', '2011-12-20';
END TRY
BEGIN CATCH
PRINT 'Error number: ' + CONVERT(varchar(100), ERROR_NUMBER());
PRINT 'Error message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;

-- PART 7

GO 
CREATE FUNCTION fnUnpaidInvoiceID()
RETURNS int
BEGIN
RETURN 
(SELECT MIN(InvoiceID) 
FROM Invoices 
WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0 AND InvoiceDueDate = 
	(SELECT MIN(InvoiceDueDate) 
	FROM Invoices 
	WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0));
END;

-- PART 8

USE AP;

SELECT VendorName, InvoiceNumber, InvoiceDueDate, InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Vendors JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE InvoiceID = dbo.fnUnpaidInvoiceID();

-- PART 9

CREATE FUNCTION fnDateRange 
(@DateMin smalldatetime, @DateMax smalldatetime)
RETURNS TABLE

RETURN
(SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceTotal - CreditTotal - PaymentTotal AS Balance 
FROM Invoices
WHERE InvoiceDate BETWEEN @DateMin AND @DateMax);

-- PART 10

SELECT *
FROM dbo.fnDateRange('12/10/11','12/20/11');

-- PART 11

 SELECT VendorName, FunctionTable. *
 FROM Vendors JOIN Invoices
 ON Vendors.VendorID = Invoices.VendorID
 JOIN dbo.fnDateRange('12/10/11','12/20/11') AS FunctionTable
 ON Invoices.InvoiceNumber = FunctionTable.InvoiceNumber;

 -- PART 12 

 CREATE TABLE ShippingLabels
 (VendorName varchar(50),
 VendorAddress1 varchar(50),
 VendorAddress2 varchar(50),
 VendorCity varchar(50),
 VendorState char(2),
 VendorZipCode varchar(20));