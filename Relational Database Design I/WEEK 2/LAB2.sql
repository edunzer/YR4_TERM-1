-- QUESTION 1
/*
Write a script that adds an index to the MyGuitarShop database for the zip code field in the
Addresses table.
*/


USE MyGuitarShop;
CREATE INDEX AddressesZipCode
ON Addresses (ZipCode);


-- QUESTION 2

/*
Write a script that implements the following design in a database named MyWebDB:
  In the Downloads table, the UserID and ProductID columns are the foreign keys.
  Include a statement to drop the database if it already exists.
  Include statements to create and select the database.
  Include any indexes that you think are necessary.
*/

USE MASTER;
IF EXISTS
(SELECT * FROM sys.databases
WHERE NAME='MyWebDB')
DROP DATABASE MyWebDB;
GO

CREATE DATABASE MyWebDB;
GO

USE MyWebDB;
CREATE TABLE Users
(UserID	INT	NOT NULL PRIMARY KEY,
EmailAddress VARCHAR(50) NULL,
FirstName VARCHAR(50) NULL,
LastName VARCHAR(50) NULL);

CREATE TABLE Products
(ProductID INT NOT NULL PRIMARY KEY,
ProductName	VARCHAR(50) NULL);

CREATE TABLE Downloads
(DownloadID	INT	NOT NULL PRIMARY KEY,
UserID	INT	NOT NULL REFERENCES Users (UserID),
DownloadDate SMALLDATETIME NULL,
FileName VARCHAR(50) NULL,
ProductID INT NOT NULL REFERENCES Products (ProductID));

CREATE INDEX IX_Downloads_UserID
ON Downloads (UserID);
CREATE INDEX IX_Downloads_ProductID
ON Downloads (ProductID);


-- QUESTION 3

/*
Write a script that adds rows to the database that you created in exercise 2.
Add two rows to the Users and Products tables.
Add three rows to the Downloads table: one row for user 1 and product 2; one for user 2
and product 1; and one for user 2 and product 2. Use the GETDATE function to insert the
current date and time into the DownloadDate column.


Write a SELECT statement that joins the three tables and retrieves the data from these
tables like this:
  email_address       first_name    last_name   download_date           filename                    product_name
  johnsmith@gmail.com John          Smith       2012-04024 16:15:38     pedals_are_falling.mp3      Local Music Vol 1
  janedoe@yahoo.com   Jane          Doe         2012-04024 16:15:38     turn_signal.mp3             Local Music Vol 1
  janedoe@yahoo.com   Jane          Doe         2012-04-24 16:15:38     one_horse_town.mp3          Local Music Vol 2
Sort the results by the email address in descending order and the product name in ascending
order.
*/

USE MyWebDB;
INSERT INTO Users
VALUES (1, 'bob@bob.com', 'Bob', 'McBobberson'),
(2, 'billy@bob.com', 'Billy', 'McBobberson');

GO
INSERT INTO Products
VALUES(1, 'ShamWow'),
(2, 'NeverDull Ginsu Knife SET');

GO
INSERT INTO Downloads
VALUES(1, 1, getdate(), 'file 1.txt', 2),
(2, 2, getdate(), 'file 2.txt', 1),
(3, 2, getdate(), 'file 3.txt', 2);

GO
SELECT u.EmailAddress AS email_address, u.FirstName AS first_name, u.LastName AS last_name, d.DownloadDate AS download_date, d.FileName AS filename, p.ProductName AS product_name
FROM Downloads d
join Users u
ON u.UserID = d.UserID
join Products p
ON p.ProductID = d.UserID
ORDER BY EmailAddress DESC, ProductName ASC

-- QUESTION 4
/*
Write an ALTER TABLE statement that adds two new columns to the Products table created
in exercise 2.
Add one column for product price that provides for three digits to the left of the decimal
point and two to the right. This column should have a default value of 9.99.
Add one column for the date and time that the product was added to the database.
*/

USE MyWebDB;
ALTER TABLE Products
ADD ProductPrice NUMERIC(5,2) DEFAULT 9.99;

GO
ALTER TABLE Products
ADD DateProductAdded SMALLDATETIME DEFAULT GETDATE();


-- QUESTION 5
/*
5.  Write an ALTER TABLE statement that modifies the Users table created in exercise 2 so the
FirstName column cannot store null values and can store a maximum of 20 characters.
Code an UPDATE statement that attempts to insert a null value into this column. It should fail
due to the not null constraint.
Code another UPDATE statement that attempts to insert a first name that’s longer than 20
characters. It should fail due to the length of the column.
*/

USE MyWebDB;
ALTER TABLE Users
ALTER COLUMN FirstName VARCHAR(20) NOT NULL;

USE MyWebDB;
UPDATE Users
SET FirstName = NULL
WHERE UserID = 1;

USE MyWebDB;
UPDATE Users
SET FirstName = '123456789012345678901'
WHERE UserID = 1;
