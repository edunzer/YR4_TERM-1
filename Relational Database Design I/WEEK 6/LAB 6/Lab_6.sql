-- LAB 6


-- PART 1

-- QUESTION 5

/* Can you please give me the correct answer for these questions. For some reaosn I cant think of how to do it, not sure if im over thinking it or what.

I was planning on using a cursor to go through the first problem but I feel like its too overkill for the questions.
*/


-- QUESTION 6

-- QUESTION 7

-- QUESTION 8

-- QUESTION 9


-- PART 2

-- QUESTION 1
/*
Write a script that:
Creates a user-defined database role named OrderEntry in the MyGuitarShop database
Give INSERT and UPDATE permission to the new role for the Orders and OrderItems table
Give SELECT permission for all user tables.
*/

USE MyGuitarShop;

CREATE ROLE OrderEntry;

GRANT INSERT, UPDATE ON Orders TO OrderEntry;
GRANT INSERT, UPDATE ON OrderItems TO OrderEntry;
GRANT SELECT ON SCHEMA::dbo TO OrderEntry;

-- QUESTION 2
/*
Creates a login ID named “RobertHalliday” with the password “HelloBob”
Sets the default database for the login to the MyGuitarShop database
Creates a user named “RobertHalliday” for the login
Assigns the user to the OrderEntry role you created in Exercise 1.
*/

CREATE LOGIN RobertHalliday WITH PASSWORD = 'HelloBob',
DEFAULT_DATABASE = MyGuitarShop;

CREATE USER RobertHalliday FOR LOGIN RobertHalliday;
ALTER ROLE OrderEntry ADD MEMBER RobertHalliday;

-- QUESTION 3
/*
Write a script that:
Uses dynamic SQL and a cursor to loop through each row of the Administrators table
Create a login ID for each row in that consists of the administrator’s first and last name with no space between
Set a temporary password of “temp” for each login
Set the default database for the login to the MyGuitarShop database
Create a user for the login with the same name as the login
Assign the user to the OrderEntry role you created in Exercise 1.
*/

DECLARE  @Administrators TABLE(firstname VARCHAR(255),lastname VARCHAR(255))

INSERT INTO @Administrators VALUES('Robert','Halliday')

DECLARE @DynamicSQL VARCHAR (max)
DECLARE @FirstName VARCHAR(255), @LastName VARCHAR(255), @updateCount int;
DECLARE Admin_Cursor CURSOR  LOCAL FAST_FORWARD FOR
SELECT FirstName, LastName
FROM @Administrators
OPEN Admin_Cursor;

FETCH NEXT FROM Admin_Cursor INTO @FirstName, @LastName;
WHILE (@@FETCH_STATUS = 0)
BEGIN

SET @DynamicSQL = 'CREATE LOGIN ' + QUOTENAME(@FirstName + @LastName) + ' WITH PASSWORD = ''temp'' ,CHECK_POLICY  = off';
EXEC(@DynamicSQL);

SET @DynamicSQL = 'ALTER LOGIN ' + QUOTENAME(@FirstName + @LastName) + 'WITH DEFAULT_DATABASE = [MyGuitarShop]';
EXEC(@DynamicSQL);

SET @DynamicSQL = 'CREATE USER ' + QUOTENAME(@FirstName + @LastName) + ' FOR LOGIN' + QUOTENAME(@FirstName + @LastName) + ';')
EXEC(@DynamicSQL)

SET @DynamicSQL = 'ALTER ROLE OrderEntry ADD MEMBER ' + QUOTENAME(@FirstName + @LastName) +';'
EXEC(@DynamicSQL)

FETCH NEXT FROM Admin_Cursor INTO @FirstName, @LastName;
END;


-- QUESTION 4
/*
Using the Management Studio:
Create a login ID named “RBrautigan” with the password “RBra9999,”
Set the default database to the MyGuitarShop database
Grant the login ID access to the MyGuitarShop database
Create a user for the login ID named “RBrautigan”
Assign the user to the OrderEntry role you created in Exercise 1.
Note: If you get an error that says “The MUST_CHANGE option is not supported”, you can deselect the “Enforce password policy” option for the login ID.
*/

-- QUESTION 5
/*
Write a script that removes the user-defined database role named OrderEntry. (Hint: This script should begin by removing all users from this role.)
*/

ALTER ROLE OrderEntry DROP MEMBER RBrautigan;
DROP ROLE OrderEntry;

-- QUESTION 6
/*
Write a script that (1) creates a schema named Admin, (2) transfers the table named Addresses from the dbo schema to the Admin schema, (3) assigns the Admin schema as the default schema for the user named RobertHalliday that you created in exercise 2, and (4) grants all standard privileges except for REFERENCES and ALTER to RobertHalliday for the Admin schema.
*/

GO
CREATE SCHEMA Admin;

GO
ALTER SCHEMA Admin TRANSFER dbo.Addresses;
ALTER USER RobertHalliday WITH DEFAULT_SCHEMA = Admin;

GRANT SELECT, UPDATE, INSERT, DELETE, EXECUTE ON SCHEMA :: Admin TO RobertHalliday;
