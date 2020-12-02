USE TermProjectDatabase;

-- TABLES ----------------------------------------------------------------------------------------------------------

CREATE TABLE BusinessAccounts (
  BusinessAccountID INT PRIMARY KEY IDENTITY(1,1),
  CompanyName VARCHAR(50),
  Street VARCHAR(50),
  City VARCHAR(50),
  PostCode VARCHAR(50),
  PhoneNumber VARCHAR(50),
  CreationDate DATE
);

CREATE TABLE WorkerAccounts (
  WorkerAccountID INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(50),
  Role VARCHAR(50),
  Email VARCHAR(50),
  PhoneNumber VARCHAR(50),
  BusinessAccountID INT,
  CreationDate DATE
);

CREATE TABLE Administrators(
  AdministratorAccountID INT PRIMARY KEY IDENTITY(1,1),
  WorkerAccountID VARCHAR(50) NOT NULL,
  Name VARCHAR(50),
  Role VARCHAR(50),
  Email VARCHAR(50),
  PhoneNumber VARCHAR(50),
  BusinessAccountID INT,
  CreationDate DATE
);

CREATE TABLE Departments(
  DepartmentAccountID INT PRIMARY KEY IDENTITY(1,1),
  DepartmentName VARCHAR(50),
  BusinessAccountID INT NOT NULL,
  CreationDate DATE
);

CREATE TABLE TaskList(
  TaskID INT PRIMARY KEY IDENTITY(1,1),
  TaskName VARCHAR(50) NOT NULL,
  Description VARCHAR(50),
  CompletionDate DATE,
  Status VARCHAR(50) DEFAULT 'Icebox' NOT NULL,
  CONSTRAINT ck_Enum  CHECK (Status IN ('IceBox','Emergency','InProgress','Testing','Completed')),
  ClaimedStatus BIT DEFAULT 0, -- BIT = 1, 0, or NULL so yes or no
  DepartmentID INT,
  WorkerAccountID VARCHAR(50) NOT NULL,
  BusinessAccountID INT NOT NULL,
  CreationDate DATE
);

CREATE TABLE TaskListAuditLog(
  TaskID INT PRIMARY KEY,
  CreatedBy VARCHAR(50) NOT NULL,
  CreationDate DATE NOT NULL,
  DeletedDate DATE NOT NULL,
  DeletedBy VARCHAR(50) NOT NULL
);

CREATE TABLE DeletedTaskList(
  TaskID INT PRIMARY KEY,
  TaskName VARCHAR(50),
  Description VARCHAR(50),
  CompletionDate DATE,
  Status VARCHAR(50) DEFAULT 'Icebox' NOT NULL,
  ClaimedStatus BIT DEFAULT 0, -- BIT = 1, 0, or NULL so yes or no
  DepartmentID INT,
  WorkerAccountID INT NOT NULL,
  BusinessAccountID VARCHAR(50) NOT NULL,
  CreationDate DATE,
  DeletedBy VARCHAR(50)
);

CREATE TABLE DeletedWorkerAccounts (
  WorkerAccountID INT PRIMARY KEY,
  Name VARCHAR(50),
  Role VARCHAR(50),
  Email VARCHAR(50),
  PhoneNumber VARCHAR(50),
  BusinessAccountID INT,
  CreationDate DATE,
  DeletedBy VARCHAR(50)
);


ALTER TABLE TaskList ADD CONSTRAINT
DefaultDateInsert DEFAULT GETDATE() FOR CreationDate


-- INSERTS ----------------------------------------------------------------------------------------------------------

INSERT INTO BusinessAccounts (CompanyName,Street,City,PostCode,PhoneNumber) VALUES
--  | CompanyName | Street | City | PostCode | PhoneNumber | CreationDate
('Garment Tech', '121 Randall Mill Drive', 'Lagrange', '60172', '508-540-6742'),
('Avid Tech', '645 Hudson Rd.', 'Downingtown', '14424', '806-440-7650'),
('Artificial Tech', '801 Lookout Lane', 'Revere', '11377', '208-469-3122'),
('Squared Shop', '7845 Old 53rd Drive', 'Monsey', '33160', '720-293-4404');


INSERT INTO WorkerAccounts (Name,Role ,Email , PhoneNumber, BusinessAccountID) VALUES
--  | Name | Role | Email | PhoneNumber | BusinessAccountID
('Roberta', 'Future Tactics Specialist', '2amine@acmta.com', '662-237-7348', 2),
('Sarah', 'Human Resonance Representative', 'wsevdam35-55x@acmta.com', '870-324-9552', 2),
('Eugene', 'Customer Infrastructure Producer', 'omahmad19r@policity.ml', '330-305-4924', 3),
('Jacob', 'Legacy Identity Technician', 'vridwan.widanj@bvzoonm.com', '469-414-1852', 2),
('Madelyn', 'Legacy Configuration Analyst', 'vridwan.widanj@bvzoonm.com','574-546-3726', 3),
('Rudy', 'Investor Mobility Orchestrator', 'kpietra8@kubeflow.info','708-485-4138', 2),
('Patrick', 'National Group Coordinator', 'jhassen_44z@twitchmasters.com','510-540-4372', 3);

INSERT INTO Administrators (WorkerAccountID,Name,Role,Email,PhoneNumber,BusinessAccountID) VALUES
--  | WorkerAccountID | Name | Role | Email | PhoneNumber | BusinessAccountID
( 5, 'Madelyn', 'Legacy Configuration Analyst', 'vridwan.widanj@bvzoonm.com','574-546-3726' ,2),
( 6, 'Rudy', 'Investor Mobility Orchestrator', 'kpietra8@kubeflow.info','708-485-4138' ,2),
( 7, 'Patrick', 'National Group Coordinator', 'jhassen_44z@twitchmasters.com','510-540-4372' ,3),
( 2,'Sarah', 'Human Resonance Representative', 'wsevdam35-55x@acmta.com', '870-324-9552', 2);

INSERT INTO Departments (DepartmentName,BusinessAccountID) VALUES
--  | DepartmentName | BusinessAccountID
( 'Production', 3),
( 'Operations', 2),
( 'HR', 2),
( 'Research and Development', 3),
( 'Purchasing', 3),
( 'Marketing', 2),
( 'Accounting and Finance', 2);

INSERT INTO TaskList (TaskName,Description,CompletionDate,Status,ClaimedStatus,DepartmentID,WorkerAccountID,BusinessAccountID) VALUES
--  | TaskName | Description | CompletionDate | Status | ClaimedStatus | DepartmentID | WorkerAccountID | BusinessAccountID
( 'Crocodile Show', 'Attend a Crocodile Show',NULL ,'IceBox',0 ,4 ,3 , 2),
( 'English Bulldog', 'Own an English Bulldog',NULL ,'InProgress',1 ,1 ,3 , 2),
( 'Models of Cars', 'Make Models of Cars',NULL ,'Emergency',0 ,3 ,3 , 2),
( 'Write a Book', 'Write a Book to Each of my Children',NULL ,'Emergency',0 ,4 ,2 , 2),
( 'Cook a Meal', 'Cook a Meal from Every Culture',NULL ,'Testing',1 ,5 ,1 , 3),
( 'Complete a Course', 'Complete a Course in Something',NULL,'IceBox', 0,4 ,4 , 3),
( 'Music Video', 'Appear in a Music Video',NULL ,'Emergency',0 ,4 ,3 , 2),
( 'Tornado', 'Chase a Tornado','08-09-2012' ,'Completed',1 ,7 ,4 , 2),
( 'First Aid', 'Learn Basic First Aid',NULL ,'IceBox',0 ,4 ,3 , 3),
( 'Poker', 'Play in a Poker Tournament',NULL ,'InProgress',1 ,4 ,1 , 2),
( 'Mountain', 'Climb a Mountain',NULL ,'IceBox',0 ,1 ,1 , 2),
( 'Riot', 'Participate in a Riot',NULL ,'IceBox',0 ,4 ,3 , 2),
( 'Home Remedies', 'Learn all About Home Remedies',NULL ,'InProgress',1 ,3 ,3 , 2),
( 'Whole Book', 'Read a Whole Book in One Day',NULL ,'Testing',1 ,7 ,3 , 2),
( 'Football Match', 'See a Football Match at the Nou Camp',NULL ,'Testing',1 ,1 ,3 , 2),
( 'Care Less', 'Care Less About What People Think',NULL ,'InProgress',1 ,1 ,3 , 3),
( 'Wig', 'Wear a Wig For a Day',NULL ,'IceBox',0 ,1 ,3 , 2),
( 'Christmas', 'Experience a White Christmas',NULL ,'InProgress',1 ,6 ,3 , 4),
( 'Help', 'Help in a Soup Kitchen',NULL ,'IceBox',0 ,4 ,3 , 2),
( 'Jellyfish', 'Own a Jellyfish Aquarium', NULL ,'IceBox',0 ,7 ,3 , 3),
( 'Inspiration', 'Make a "Wall of Inspiration" in my Room',NULL ,'Testing',1 ,3 ,2 , 3),
( 'Chimpanzee', 'Hang Out With a Chimpanzee',NULL ,'Testing',1 ,2 ,2 , 2),
( 'Catfish', 'Hold a Catfish','08-21-2012' ,'Completed',1 ,6 ,2 , 2),
( 'Muffin', 'Make a Muffin Cake','02-14-2013' ,'Completed',1 ,7 ,4 , 4),
( 'TED', 'Attend a TED Talk','03-02-2013' ,'Completed',1 ,5 ,2 , 2),
( 'Taj Mahal', 'See Taj Mahal',NULL ,'Emergency',0 ,4 ,3 , 2),
( 'Tough Mudder', 'Compete in Tough Mudder',NULL ,'Emergency',0 ,1 ,2 , 3),
( 'Nighter', 'Pull an all Nighter',NULL ,'Emergency',0 ,3 ,3 , 2);


-- TRIGGERS ----------------------------------------------------------------------------------------------------------

-- TRIGGER to set the ClaimedStatus to 1 when a new task is created and has a status that is not IceBox or Emergency.
CREATE TRIGGER TrgNotClaimedStatus
ON TaskList AFTER UPDATE AS
BEGIN
UPDATE TaskList
SET ClaimedStatus = 1
WHERE Status != 'IceBox' OR Status != 'Emergency'
END;

-- TRIGGER to set the ClaimedStatus to 0 when a new task is created and has a status that is IceBox or Emergency.
CREATE TRIGGER TrgClaimedStatus
ON TaskList AFTER UPDATE AS
BEGIN
UPDATE TaskList
SET ClaimedStatus = 0
WHERE Status = 'IceBox' OR Status != 'Emergency'
END;

-- TRIGGER to record the CompletionDate of a task when the status is changed to Completed.
CREATE TRIGGER TrgCompletionDate
ON TaskList AFTER UPDATE AS
BEGIN
DECLARE @DateTime = GETDATE();
UPDATE A
SET CompletionDate = CONVERT(DATE, @DateTime)
FROM TaskList AS A
WHERE Status = 'Completed'
END;

-- TRIGGER to record the TaskID, DeletedDate, and who deleted said task. Inserts into TaskListAuditLog table
CREATE TRIGGER TrgTaskDelete
ON TaskList AFTER DELETE AS
BEGIN
DECLARE vUser VARCHAR(50);
SELECT USER() INTO vUser;
INSERT INTO TaskListAuditLog
(TaskID,DeletedDate,DeletedBy)
VALUES(OLD.TaskID, SYSDATE(),vUser );
END;

-- TRIGGER to record the TaskID, CreationDate, and who created said task. Inserts into TaskListAuditLog table
CREATE TRIGGER TrgTaskCreate
ON TaskList AFTER INSERT AS
BEGIN
DECLARE vUser VARCHAR(50);
SELECT USER() INTO vUser;
INSERT INTO TaskListAuditLog
(TaskID,CreationDate,CreatedBy)
VALUES(NEW.TaskID, SYSDATE(),vUser );
END;

-- TRIGGER to record who created a task.
CREATE TRIGGER TrgWorkerTaskCreation
BEFORE INSERT ON TaskList FOR EACH ROW
BEGIN
SELECT USER() INTO vUser;
INSERT INTO TaskList(WorkerAccountID)
VALUES(vUser);
END;

-- TRIGGER to move task to DeletedTaskList and add DeletedBy.
CREATE TRIGGER TrgTaskDeleteMove
ON TaskList AFTER DELETE AS
BEGIN TRANSACTION

BEGIN TRY
INSERT INTO DeletedTaskList (TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList
END TRY

BEGIN TRY
SELECT USER() INTO vUser
INSERT INTO DeletedTaskList(DeletedBy)
VALUES(vUser)
END TRY
COMMIT TRANSACTION

BEGIN CATCH
THROW 51000, 'The records do not exist.', 1;
ROLLBACK TRANSACTION
END CATCH;

-- TRIGGER to move WorkerAccounts to DeletedWorkerAccounts and add DeletedBy.
CREATE TRIGGER TrgWorkerDeleteMove
ON WorkerAccounts AFTER DELETE AS
BEGIN TRANSACTION

BEGIN TRY
INSERT INTO DeletedWorkerAccounts (WorkerAccountID, Name, Role, Email, PhoneNumber, BusinessAccountID, CreationDate)
SELECT WorkerAccountID, Name, Role, Email, PhoneNumber, BusinessAccountID, CreationDate
FROM TaskList
END TRY

BEGIN TRY
SELECT USER() INTO vUser
INSERT INTO DeletedWorkerAccounts(DeletedBy)
VALUES(vUser)
END TRY
COMMIT TRANSACTION

BEGIN CATCH
THROW 51000, 'The records do not exist.', 1;
ROLLBACK TRANSACTION
END CATCH;

-- SEQUENCES AND TRIGGER FOR AUTO INCREMENT -----------------------------------------------------------------------------------------
-- THIS DOESNT WORK BUT I WOULD APPRECIATE IT IF YOU COULD FIGURE OUT WHY
-- THE PROBLEM IS THAT IT CANT FIND THE MAX(VALUES) SO IN THE FIRST ONE, IT CANT FIND THE MAX OF WorkerAccountID

CREATE SEQUENCE WorkerAccountIDSeq
START WITH MAX(WorkerAccountID) + 1
INCREMENT BY 1
CACHE 10000;

CREATE SEQUENCE BusinessAccountIDSeq
START WITH MAX(BusinessAccountID) + 1
INCREMENT BY 1
CACHE 10000;

CREATE SEQUENCE AdministratorAccountIDSeq
START WITH MAX(AdministratorAccountID) + 1
INCREMENT BY 1
CACHE 10000;

CREATE SEQUENCE DepartmentAccountIDSeq
START WITH MAX(DepartmentAccountID) + 1
INCREMENT BY 1
CACHE 10000;

CREATE SEQUENCE TaskIDSeq
START WITH MAX(TaskID) + 1
INCREMENT BY 1
CACHE 10000;

-- TRIGGER to change the value of WorkerAccountID
CREATE OR REPLACE TRIGGER TrgWorkerAccountID
BEFORE INSERT ON WorkerAccounts
FOR EACH ROW
BEGIN
:new.WorkerAccountID:=WorkerAccountIDSeq.nextval;
END;

-- TRIGGER to change the value of BusinessAccountID
CREATE OR REPLACE TRIGGER TrgBusinessAccountID
BEFORE INSERT ON BusinessAccounts
FOR EACH ROW
BEGIN
:new.BusinessAccountID:=BusinessAccountIDSeq.nextval;
END;

-- TRIGGER to change the value of AdministratorAccountID
CREATE OR REPLACE TRIGGER TrgAdministratorAccountID
BEFORE INSERT ON Administrators
FOR EACH ROW
BEGIN
:new.AdministratorAccountID:=AdministratorAccountIDSeq.nextval;
END;

-- TRIGGER to change the value of DepartmentAccountID
CREATE OR REPLACE TRIGGER TrgDepartmentAccountID
BEFORE INSERT ON Departments
FOR EACH ROW
BEGIN
:new.DepartmentAccountID:=DepartmentAccountIDSeq.nextval;
END;

-- TRIGGER to change the value of TaskID
CREATE OR REPLACE TRIGGER TrgTaskID
BEFORE INSERT ON TaskList
FOR EACH ROW
BEGIN
:new.TaskID:=TaskIDSeq.nextval;
END;

-- INDEXES ----------------------------------------------------------------------------------------------------------

CREATE INDEX IdxCompleted
ON TaskList (Status)
WHERE Status = 'Completed'

CREATE INDEX IdxTesting
ON TaskList (Status)
WHERE Status = 'Testing'

CREATE INDEX IdxInProgress
ON TaskList (Status)
WHERE Status = 'InProgress'

CREATE INDEX IdxEmergency
ON TaskList (Status)
WHERE Status = 'Emergency'

CREATE INDEX IdxIceBox
ON TaskList (Status)
WHERE Status = 'IceBox'

CREATE INDEX IdxWorkers
ON WorkerAccounts (WorkerAccountID, Name)


-- FUCNTIONS -----------------------------------------------------------------------------------------------------------

-- FUNCTION to calculate how many tasks a worker has
CREATE FUNCTION FnEmployeeActiveTaskReview(@WorkerAccountID VARCHAR)
RETURNS DECIMAL
BEGIN
RETURN (SELECT COUNT(*) AS TaskCount FROM TaskList WHERE Status != 'Completed' AND WorkerAccountID = @WorkerAccountID)
END;

-- FUNCTION to calculate the top workers with the most completed tasks
CREATE FUNCTION FnEmployeeTaskComparisonReview(@Status VARCHAR)
RETURNS TABLE
AS
RETURN (SELECT TaskList.WorkerAccountID, Name, (SELECT WorkerAccountID, COUNT(*) FROM TaskList GROUP BY WorkerAccountID) AS TaskCount
FROM WorkerAccounts INNER JOIN TaskList ON WorkerAccounts.WorkerAccountID = TaskList.WorkerAccountID
WHERE Status = @Status
ORDER BY TaskCount);


-- PROCEDURES ----------------------------------------------------------------------------------------------------------

-- PROC to insert into the TaskList table.
CREATE PROC SpInsertTask
@TaskName VARCHAR,
@Description VARCHAR,
@CompletionDate DATE,
@Status VARCHAR,
@ClaimedStatus BIT,
@DepartmentID INT,
@WorkerAccountID VARCHAR,
@BusinessAccountID INT,
@CreationDate DATE

AS

IF @TaskName IS NULL THROW 50001, 'Please fill out the TaskName feild.', 1;
IF @DepartmentID IS NULL THROW 50002, 'Please fill out the DepartmentID feild.', 1;
IF @BusinessAccountID IS NULL THROW 50003, 'Please fill out the BusinessAccountID feild.', 1;

BEGIN TRANSACTION
BEGIN TRY
INSERT INTO TaskList(TaskName, Description, CompletionDate, Status, ClaimedStatus, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)
VALUES (@TaskName, @Description, @CompletionDate = NULL, @Status, @ClaimedStatus, @DepartmentID, @WorkerAccountID, @BusinessAccountID, @CreationDate = GETDATE())
COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
THROW 50004, 'The Query should be in this format: TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID', 1;
END CATCH;


-- PROC to insert into the Departments table.
CREATE PROC SpInsertDepartment
@DepartmentName VARCHAR,
@BusinessAccountID INT,
@CreationDate DATE

AS

IF @BusinessAccountID IS NULL THROW 50003, 'Please fill out the BusinessAccountID feild.', 1;

BEGIN TRANSACTION
BEGIN TRY
INSERT INTO Departments(DepartmentName, BusinessAccountID, CreationDate)
VALUES (@DepartmentName, @BusinessAccountID, @CreationDate = GETDATE())
COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
THROW 50004, 'The Query should be in this format: DepartmentName, BusinessAccountID, CreationDate', 1;
END CATCH;

-- PROC to insert into the Administrators table.
CREATE PROC SpInsertAdministratorAccount
@WorkerAccountID VARCHAR,
@Name VARCHAR,
@Role VARCHAR,
@Email VARCHAR,
@PhoneNumber INT,
@BusinessAccountID INT,
@CreationDate DATE

AS

IF @WorkerAccountID IS NULL THROW 50005, 'Please fill out the WorkerAccountID feild.', 1;
IF @BusinessAccountID IS NULL THROW 50003, 'Please fill out the BusinessAccountID feild.', 1;

BEGIN TRANSACTION
BEGIN TRY
INSERT INTO Administrators(WorkerAccountID, Name, Role, Email, PhoneNumber, BusinessAccountID, CreationDate)
VALUES (@WorkerAccountID, @Name, @Role, @Email, @PhoneNumber, @BusinessAccountID, @CreationDate = GETDATE())
COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
THROW 50004, 'The Query should be in this format: WorkerAccountID, Name, Role, Email, PhoneNumber, BusinessAccountID', 1;
END CATCH;

-- PROC to insert into the WorkerAccounts table.
CREATE PROC SpInsertWorkerAccount
@Name VARCHAR,
@Role VARCHAR,
@Email VARCHAR,
@PhoneNumber INT,
@BusinessAccountID INT,
@CreationDate DATE

AS

IF @Name IS NULL THROW 50006, 'Please fill out the Name feild.', 1;
IF @BusinessAccountID IS NULL THROW 50003, 'Please fill out the BusinessAccountID feild.', 1;

BEGIN TRANSACTION
BEGIN TRY
INSERT INTO WorkerAccounts(Name, Role, Email, PhoneNumber, BusinessAccountID, CreationDate)
VALUES (@Name, @Role, @Email, @PhoneNumber, @BusinessAccountID, @CreationDate = GETDATE())
COMMIT TRANSACTION
END TRY


BEGIN CATCH
ROLLBACK TRANSACTION
THROW 50004, 'The Query should be in this format: Name, Role, Email, PhoneNumber, BusinessAccountID', 1;
END CATCH;

-- PROC to insert into the BusinessAccounts table.
CREATE PROC SpInsertBusinessAccount
@CompanyName VARCHAR,
@Street VARCHAR,
@City VARCHAR,
@PostCode INT,
@PhoneNumber INT,
@CreationDate DATE

AS

IF @CompanyName IS NULL THROW 50007, 'Please fill out the CompanyName feild.', 1;

BEGIN TRANSACTION
BEGIN TRY
INSERT INTO BusinessAccounts(CompanyName, Street, City, PostCode, PhoneNumber, CreationDate)
VALUES (@CompanyName, @Street, @City, @PostCode, @PhoneNumber, @CreationDate = GETDATE())
COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
THROW 50004, 'The Query should be in this format: CompanyName, Street, City, PostCode, PhoneNumber', 1;
END CATCH;

-- PROC to move all tasks with a certain WorkerAccountID to a new department
CREATE PROC SpWorkerDepartmentChange
@WorkerAccountID VARCHAR(50),
@DepartmentID INT

AS

IF @WorkerAccountID IS NULL THROW 50005, 'Please fill out the WorkerAccountID feild.', 1;
IF @DepartmentID IS NULL THROW 50002, 'Please fill out the DepartmentID feild.', 1;

BEGIN TRANSACTION
BEGIN TRY
UPDATE TaskList
SET DepartmentID = @DepartmentID
WHERE WorkerAccountID = @WorkerAccountID
COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
THROW 50004, 'The Query should be in this format: WorkerAccountID, DepartmentID', 1;
END CATCH;

-- VIEWS ----------------------------------------------------------------------------------------------------------

CREATE VIEW TaskByDepartment AS
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList

CREATE VIEW EmployeeByDepartment AS
SELECT WorkerAccountID, Name, Role, Email, PhoneNumber, BusinessAccountID, CreationDate
FROM WorkerAccounts

CREATE VIEW IceBox AS
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList
WHERE Status = 'IceBox'

CREATE VIEW Emergency AS
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList
WHERE Status = 'Emergency'

CREATE VIEW InProgress AS
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList
WHERE Status = 'InProgress'

CREATE VIEW Testing AS
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList
WHERE Status = 'Testing'

CREATE VIEW Completed AS
SELECT TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate
FROM TaskList
WHERE Status = 'Completed'

CREATE VIEW EmployeeTaskCompletionReview AS
SELECT FnEmployeeTaskCompletionReview('Completed')
FROM TaskList
