-- QUESTION 1

USE AP;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceLineItemDescription AS ItemDescription, InvoiceLineItemAmount AS ItemAmount
FROM Invoices AS Invoice JOIN InvoiceLineItems AS LineItem
    ON Invoice.InvoiceID = LineItem.InvoiceID
WHERE Invoice.InvoiceID IN (
    SELECT Invoices.InvoiceID
    FROM Invoices JOIN InvoiceLineItems
        ON Invoices.InvoiceID = InvoiceLineItems.InvoiceID
    GROUP BY Invoices.InvoiceID
    HAVING COUNT(InvoiceLineItemDescription) > 1)
ORDER BY InvoiceDate
FOR XML AUTO, ROOT ('MultipleLineItems'), ELEMENTS;



-- QUESTION 2

USE AP;

DECLARE @ContactUpdate XML;
SET @ContactUpdate = '
<ContactUpdates>
  <Contact VendorID="4">
    <LastName>McCrystle</LastName>
    <FirstName>Timothy</FirstName>
  </Contact>
  <Contact VendorID="10">
    <LastName>Flynn</LastName>
    <FirstName>Erin</FirstName>
  </Contact>
</ContactUpdates>
'
;

UPDATE Vendors
SET VendorContactLName = @ContactUpdate.value(
    '(/ContactUpdates/Contact/LastName)[1]', 'varchar(50)'),
  VendorContactFName = @ContactUpdate.value(
    '(/ContactUpdates/Contact/FirstName)[1]', 'varchar(50)')
WHERE VendorID = @ContactUpdate.value(
    '(/ContactUpdates/Contact/@VendorID)[1]', 'int');

UPDATE Vendors
SET VendorContactLName = @ContactUpdate.value(
    '(/ContactUpdates/Contact/LastName)[2]', 'varchar(50)'),
  VendorContactFName = @ContactUpdate.value(
    '(/ContactUpdates/Contact/FirstName)[2]', 'varchar(50)')
WHERE VendorID = @ContactUpdate.value(
    '(/ContactUpdates/Contact/@VendorID)[2]', 'int');


-- QUESTION 3

USE AP;

-- Declare an int variable that's a handle for the internal XML document
DECLARE @ContactUpdatesHandle int;

-- Create an xml variable that stores the XML document
DECLARE @ContactUpdates xml;
SET @ContactUpdates = '
<ContactUpdates>
  <Contact VendorID="4">
    <LastName>McCrystle</LastName>
    <FirstName>Timothy</FirstName>
  </Contact>
  <Contact VendorID="10">
    <LastName>Flynn</LastName>
    <FirstName>Erin</FirstName>
  </Contact>
</ContactUpdates>
'
;

-- Prepare the internal XML document
EXEC sp_Xml_PrepareDocument @ContactUpdatesHandle OUTPUT, @ContactUpdates;

-- SELECT the data from the table returned by the OPENXML statement
SELECT *
FROM OPENXML (@ContactUpdatesHandle, '/ContactUpdates/Contact')
WITH
(
	VendorID   int          '@VendorID',
	FirstName  varchar(50)  'FirstName',
	LastName   varchar(50)  'LastName'
);

-- Remove the internal XML document
EXEC sp_Xml_RemoveDocument @ContactUpdatesHandle;


-- QUESTION 4

USE AP;

CREATE TABLE Instructions
(InstructionsID int NOT NULL IDENTITY PRIMARY KEY,
Instructions xml NOT NULL);

DECLARE @InstructionsXML xml;
SET @InstructionsXML =
'
<Instructions>
  <Step>
    <Description>This is the first step.</Description>
    <SubStep>This is the first substep.</SubStep>
    <SubStep>This is the second substep.</SubStep>
  </Step>
  <Step>
    <Description>This is the second step.</Description>
  </Step>
  <Step>
    <Description>This is the third step.</Description>
  </Step>
</Instructions>
'
;

INSERT INTO Instructions VALUES (@InstructionsXML);

SELECT * FROM Instructions;
