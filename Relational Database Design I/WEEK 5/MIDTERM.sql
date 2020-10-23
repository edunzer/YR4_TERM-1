-- QUESTION 1
/*
USING AP Database

Write a SELECT statement that returns two columns based on the Vendors table. The first column, Contact, is the vendor contact name in this format: first name followed by last initial (for example, "John S") The second column, Phone, is the VendorPhone column without the area code. Only return rows for those vendors in the 559 area code. Sort the result set by first name, then last name.
*/

SELECT VendorContactFName +' '+ LEFT(VendorContactLName, 1) AS Contact, RIGHT(VendorPhone,8) AS Phone
FROM Vendors
WHERE SUBSTRING(VendorPhone,2,3)=559
ORDER BY VendorContactFName, VendorContactLName

-- QUESTION 2
/*
Write a SELECT statement that returns the InvoiceNumber and balance due for every invoice with a non-zero balance and an InvoiceDueDate that's less than 30 days from today.
*/

SELECT InvoiceNumber, InvoiceTotal AS Balance
FROM Invoices
WHERE CreditTotal > 0 AND (DATEDIFF(Day, InvoiceDueDate, GETDATE()) < 30)

-- QUESTION 3
/*
Modify the search expression for InvoiceDueDate from the solution for question 2. Rather than 30 days from today, return invoices due before the last day of the current month.
*/

SELECT InvoiceNumber, InvoiceTotal AS Balance, DATEADD(month, DATEDIFF(month, 0, GETDATE()) +1, -1)
FROM Invoices
WHERE InvoiceDueDate <= DATEADD(month, DATEDIFF(month, 0, GETDATE()) +1, -1)

-- QUESTION 4
/*
Create a new database named MembershipTest.
*/

CREATE DATABASE MembershipTest;

-- QUESTION 5
/*
Write the CREATE TABLE statements needed to implement the following design in the MembershipTest database. Include foreign key constraints. Define PersonlD and GroupID as identity columns. Decide which columns should allow null values, if any, and explain your decision. Define the Dues column with a default of zero and a check constraint to allow only positive values.
*/

CREATE TABLE Persons
(PersonsID INT NOT NULL IDENTITY PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Address VARCHAR(100) NULL,
Phone VARCHAR(50) NULL);

CREATE TABLE Groups
(GroupID INT NOT NULL IDENTITY PRIMARY KEY,
GroupName VARCHAR(50) NOT NULL,
Dues MONEY NOT NULL DEFAULT 0 CHECK (Dues >= 0));

CREATE TABLE GroupMembership
(GroupID INT REFERENCES Groups(GroupID),
PersonsID INT REFERENCES Persons(PersonsID));

-- QUESTION 6
/*
Write the CREATE INDEX statements to create a clustered index on the GroupID column and a nonclustered index on the PersonlD column of the GroupMembership table.
*/

CREATE CLUSTERED INDEX GroupMembershipGroupID
ON GroupMembership(GroupID)
CREATE INDEX GroupMembershipIndividualID
ON GroupMembership(PersonsID);

-- QUESTION 7
/*
Write an ALTER TABLE statement that adds a new column, DuesPaid, to the Persons table. Use the bit data type, disallow null values, and assign a default Boolean value of False.
*/

ALTER TABLE Persons
ADD DuesPaid BIT NOT NULL DEFAULT 0;

-- QUESTION 8
/*
Write a CREATE VIEW statement that defines a view named InvoiceBasic that returns three columns: VendorName, InvoiceNumber, and InvoiceTotal. Then, write a SELECT statement that returns all of the columns in the view, sorted by VendorName, where the first letter of the vendor name is N, O, or P
*/

CREATE VIEW InvoiceBasic
AS
SELECT VendorName, InvoiceNumber, InvoiceTotal
FROM Vendors JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID;

SELECT *
FROM InvoiceBasic
WHERE LEFT(VendorName,1) IN ('N','O','P')
ORDER BY VendorName

-- QUESTION 9
/*
Create a view named Top10PaidInvoices that returns three columns for each vendor: VendorName, Lastlnvoice (the most recent invoice date), and SumOflnvoices (the sum of the InvoiceTotal column). Return only the 10 vendors with the largest SumOfInvoices and include only paid invoices.
*/

CREATE VIEW Top10PaidInvoices
AS
SELECT TOP 10 VendorName AS Name, MAX(InvoiceDate) AS LastInvoice, SUM(InvoiceTotal) AS SumOfInvoices
FROM dbo.Vendors V JOIN dbo.Invoices I
ON V.VendorID = I.VendorID
WHERE PaymentDate IS NOT NULL
GROUP BY VendorName
ORDER BY SumOFInvoices DESC;

-- QUESTION 10
/*
Write a script that declares and sets a variable that's equal to the total outstanding balance due. If that balance due is greater than $10,000.00, the script should return a result set consisting of VendorName, InvoiceNumber, InvoiceDueDate, and Balance for each invoice with a balance due, sorted with the oldest due date first. If the total outstanding balance due is less than $10,000.00, the script should return the message "Balance due is less than $10,000.00."
*/

USE AP
DECLARE @TotalDue MONEY

SELECT @TotalDue = SUM(InvoiceTotal - PaymentTotal - CreditTotal)
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
IF @TotalDue > 10000

BEGIN

SELECT VendorName, InvoiceNumber, InvoiceDueDate,
InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Invoices JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 10000
ORDER BY InvoiceDueDate

END

-- QUESTION 11
/*
Return the date and invoice total of the earliest invoice issued by each vendor. Write a script that generates the result set that uses a temporary table.
*/

USE AP

SELECT VendorName, FirstInvoiceDate, InvoiceTotal
FROM Invoices JOIN
(SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
FROM Invoices
GROUP BY VendorID) AS FirstInvoice
ON (Invoices.VendorID = FirstInvoice.VendorID AND Invoices.InvoiceDate = FirstInvoice.FirstInvoiceDate)
JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
ORDER BY VendorName, FirstInvoiceDate

-- QUESTION 12
/*
Write a script that generates the same result set as the code shown in question11, but uses a view instead of a derived table. Write the script that creates the view.
*/

CREATE VIEW EarliestVendorInvoice
AS

SELECT VendorName, FirstInvoiceDate, InvoiceTotal
FROM Invoices JOIN
(SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
FROM Invoices
GROUP BY VendorID) AS FirstInvoice
ON (Invoices.VendorID = FirstInvoice.VendorID AND Invoices.InvoiceDate = FirstInvoice.FirstInvoiceDate)
JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
ORDER BY VendorName, FirstInvoiceDate

-- QUESTION 13
/*
Create a stored procedure named spDateRange that accepts two parameters, @DateMin and @DateMax, with data type varchar and default value null. If called with no parameters or with null values, raise an error that describes the problem. If called with non-null values, validate the parameters. Test that the literal strings are valid dates and test that @DateMin is earlier than @DateMax. If the parameters are valid, return a result set that includes the InvoiceNumber, InvoiceDate, InvoiceTotal, and Balance for each invoice for which the InvoiceDate is within the date range, sorted with earliest invoice first.
*/

CREATE PROC spDateRange
@DateMin VARCHAR(20) = NULL,
@DateMax VARCHAR(20) = NULL

AS

IF @DateMin IS NULL THROW 50001,'Minimum Date Left Blank',1;
IF @DateMax IS NULL THROW 50002,'Maximum Date Left Blank',1;
IF ISDATE(@DateMin) = 0 THROW 50003,'Minimum is not a valid date',1;
IF ISDATE(@Datemax) = 0 THROW 50004,'Maximum is not a valid date',1;

IF (SELECT CONVERT(DATETIME,@DateMin))>(SELECT CONVERT(DATETIME,@DateMax))THROW 50005,'Min date is greater than max date',1;
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,(InvoiceTotal -CreditTotal -PaymentTotal)
AS Balance
FROM Invoices
WHERE InvoiceDate >CONVERT(DATETIME,@DateMin) AND InvoiceDate <CONVERT(DATETIME,@DateMax)
ORDER BY InvoiceDate DESC;

-- QUESTION 14
/*
Code a call to the stored procedure created in exercise 13 that returns invoices with an InvoiceDate between December 20 and December 10, 2011. This call should also catch any errors that are raised by the procedure and print the error number and description.
*/

EXEC spDateRange '2011-12-10', '2011-12-20'

-- QUESTION 15
/*
Create a scalar-valued function named fnUnpaidInvoiceID that returns the InvoiceID of the earliest invoice with an unpaid balance.
*/

CREATE FUNCTION fnUnpaidInvoiceID()
RETURNS INT
AS

BEGIN
DECLARE @InvoiceID INT;
SET @InvoiceID = (SELECT TOP 1 InvoiceID
FROM Invoices
WHERE (InvoiceTotal - CreditTotal - PaymentTotal) > 0
ORDER BY InvoiceDate);
RETURN (@InvoiceID);
END

-- QUESTION 16
/*
Create a table-valued function named fnDateRange. The function requires two parameters of data type smalldatetime. Don't validate the parameters. Return a result set that includes the InvoiceNumber, InvoiceDate, InvoiceTotal, and Balance for each invoice for which the InvoiceDate is within the date range. Invoke the function from within a SELECT statement to return those invoices with InvoiceDate between December 10 and December 20, 2011.
*/

CREATE FUNCTION fnDateRange (@DateMin SMALLDATETIME = NULL, @DateMax SMALLDATETIME = NULL)
RETURNS TABLE
AS
RETURN (SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Invoices
WHERE InvoiceDate BETWEEN @DateMin AND @DateMax);

GO


SELECT dbo.fnDateRange('2011-12-10', '2011-12-20')

-- QUESTION 17
/*
Use the function you created in exercise 16 in a SELECT statement that returns five columns: VendorName and the four columns returned by the function.
*/

SELECT VendorName, dbo.fnDateRange('2011-12-10', '2011-12-20')
FROM Vendors, Invoices
WHERE Vendors.VendorID = Invoices.VendorID

-- QUESTION 18
/*
Create a trigger in the AP database for the Invoices table that automatically inserts the vendor name and address for a paid invoice into a table named ShippingLabels. The trigger should fire any time the PaymentTotal column of the Invoices table is updated. The structure of the ShippingLabels table is as follows:

                     CREATE TABLE ShippingLabels

( VendorÑame varchar(50,
  VendorAddress1 varchar(50
  VendorAddress2 varchar(50),
  VendorCity varchar(50),
  VendorState char(2),
  VendorZipCode varchar(20));
*/

CREATE TRIGGER InvoicesShippingLabelsTrigger
ON Invoices AFTER UPDATE

AS
INSERT INTO shippinglabels (VendorName, VendorAddress1, VendorAddress2, VendorCity, VendorState, VendorZipCode)
SELECT VendorName, VendorAddress1, VendorAddress2, VendorCity, VendorState,VendorZipCode
FROM Inserted AS I INNER JOIN Deleted AS D ON i.InvoiceID=d.InvoiceID INNER JOIN Vendors AS V ON I.InvoiceID=v.InvoiceID
WHERE i.paymentTotal <> d.PaymentTotal

-- QUESTION 19
/*
Write a trigger that prohibits duplicate values except for nulls in the NoDupName column of the following table:

CREATE TABLE TestUniqueNulls

(RowID            int IDENTITY NOT NULL,

NoDupName     varchar(20)      NULL)
*/

CREATE TRIGGER NoDuplicates
ON TestUniqueNulls
AFTER INSERT, UPDATE AS
BEGIN

IF
(SELECT COUNT(DISTINCT A.NoDupName) AS DistinctCount
FROM TestUniqueNulls AS A INNER JOIN Inserted AS B ON A.NoDupName = B.noDupName) > 1

BEGIN
ROLLBACK Tran
RaisError ('Duplicate value', 11, 1)

END
END
GO
