-- QUESTION 1

USE MyGuitarShop;
CREATE INDEX AddressesZipCode
ON Addresses (ZipCode);


-- QUESTION 2

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


USE MyWebDB;
ALTER TABLE Products
ADD ProductPrice NUMERIC(5,2) DEFAULT 9.99;

GO
ALTER TABLE Products
ADD DateProductAdded SMALLDATETIME DEFAULT GETDATE();


-- QUESTION 5

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
