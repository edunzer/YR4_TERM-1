-- TABLES --

CREATE TABLE BusinessAccounts (
  BusinessAccountID INT PRIMARY KEY,
  CompanyName VARCHAR(50),
  Street VARCHAR(50),
  City VARCHAR(50),
  PostCode INT,
  PhoneNumber INT,
  CreationDate DATE NOT NULL
);

CREATE TABLE WorkerAccounts (
  WorkerAccountID INT PRIMARY KEY,
  Name VARCHAR(50),
  Role VARCHAR(50),
  Email VARCHAR(50),
  Phone INT,
  BusinessAccountID INT,
  CreationDate DATE NOT NULL
);

CREATE TABLE Administrators(
  AdministratorAccountID INT PRIMARY KEY,
  WorkerAccountID INT NOT NULL,
  Name VARCHAR(50)
  Role VARCHAR(50),
  Email VARCHAR(50),
  Phone INT,
  BusinessAccountID INT,
  CreationDate DATE NOT NULL
);

CREATE TABLE Departments(
  DepartmentAccountID INT PRIMARY KEY,
  DepartmentName VARCHAR(50),
  BusinessAccountID INT NOT NULL,
  CreationDate DATE NOT NULL
);

CREATE TABLE TaskList(
  TaskID INT PRIMARY KEY,
  TaskName VARCHAR(50) PRIMARY KEY,
  Description VARCHAR(50),
  CompletionDate DATE,
  Status ENUM('IceBox','Emergency','InProgress','Testing','Completed') DEFAULT 'IceBox' NOT NULL,
  DepartmentID INT,
  WorkerAccountID INT NOT NULL, -- ADD trigger to grab the AccountID of person who creates this task
  BusinessAccountID INT NOT NULL,
  CreationDate DATE NOT NULL
);

CREATE TABLE EmployeeTaskCompleteionReview(
  BusinessAccountID INT NOT NULL,
  WorkerAccountID INT NOT NULL,
  Name VARCHAR(50),
  TaskCount INT
);

CREATE TABLE IceBox(
  BusinessAccountID INT NOT NULL,
  TaskID INT NOT NULL,
  TaskName VARCHAR(50),
  Status ENUM('IceBox','Emergency','InProgress','Testing','Completed') NOT NULL,
  ClaimedStatus BIT DEFAULT 0, -- BIT = 1, 0, or NULL so yes or no
  DepartmentID INT NOT NULL,
);

CREATE TABLE Emergency(
  BusinessAccountID INT NOT NULL,
  TaskID INT NOT NULL,
  TaskName VARCHAR(50),
  Status ENUM('IceBox','Emergency','InProgress','Testing','Completed') NOT NULL,
  ClaimedStatus BIT, -- BIT = 1, 0, or NULL so yes or no
  DepartmentID INT NOT NULL,
);

CREATE TABLE InProgress(
  BusinessAccountID INT NOT NULL,
  TaskID INT NOT NULL,
  TaskName VARCHAR(50),
  Status ENUM('IceBox','Emergency','InProgress','Testing','Completed') NOT NULL,
  DepartmentID INT NOT NULL,
);

CREATE TABLE Testing(
  BusinessAccountID INT NOT NULL,
  TaskID INT NOT NULL,
  TaskName VARCHAR(50),
  Status ENUM('IceBox','Emergency','InProgress','Testing','Completed') NOT NULL,
  DepartmentID INT NOT NULL,
);

CREATE TABLE Completed(
  BusinessAccountID INT NOT NULL,
  TaskID INT NOT NULL,
  TaskName VARCHAR(50),
  CompletionDate DATE,
  Status ENUM('IceBox','Emergency','InProgress','Testing','Completed') NOT NULL,
  DepartmentID INT NOT NULL,
  CONSTRAINT ChkCompleted CHECK (Status = 'Completed')
);

-- VIEWS --

CREATE VIEW EmployeeTaskCompleteionReview AS
SELECT Name, (SELECT WorkerAccountID, COUNT(*) FROM TaskList GROUP BY WorkerAccountID) AS TaskCount
FROM TaskList
WHERE Status = 'Completed' -- JOIN TABLES TO GRAB NAME AND WorkerAccountID FROM WorkerAccounts TABLE
ORDER BY TaskCount



-- SEQUENCES --

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

-- TRIGGERS --

CREATE OR REPLACE TRIGGER TrgWorkerAccountID
BEFORE INSERT ON WorkerAccounts
FOR EACH ROW
BEGIN
:new.WorkerAccountID:=WorkerAccountIDSeq.nextval;
END;

CREATE OR REPLACE TRIGGER TrgBusinessAccountID
BEFORE INSERT ON BusinessAccounts
FOR EACH ROW
BEGIN
:new.BusinessAccountID:=BusinessAccountIDSeq.nextval;
END;

CREATE OR REPLACE TRIGGER TrgAdministratorAccountID
BEFORE INSERT ON Administrators
FOR EACH ROW
BEGIN
:new.AdministratorAccountID:=AdministratorAccountIDSeq.nextval;
END;

CREATE OR REPLACE TRIGGER TrgDepartmentAccountID
BEFORE INSERT ON Departments
FOR EACH ROW
BEGIN
:new.DepartmentAccountID:=DepartmentAccountIDSeq.nextval;
END;

CREATE OR REPLACE TRIGGER TrgTaskID
BEFORE INSERT ON TaskList
FOR EACH ROW
BEGIN
:new.TaskID:=TaskIDSeq.nextval;
END;

-- ADD TRIGGERS FOR CREATION DATE -------------------------------------------------
-- ADD TRIGGERS TO INSERT TASK INTO NEW TABLE WHEN STATUS CHANGED ------------------


CREATE TRIGGER StatusChange
AFTER UPDATE ON TaskList

BEGIN
DECLARE @StatusVar
DECLARE @OriginalLocation

SELECT @StatusVar = Status, @OriginalLocation =
FROM TaskList


IF @StatusVar = 'IceBox' INSERT INTO IceBox(TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)

IF @StatusVar = 'Emergency' INSERT INTO Emergency(TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)

IF @StatusVar = 'InProgress' INSERT INTO InProgress(TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)

IF @StatusVar = 'Testing' INSERT INTO Testing(TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)

IF @StatusVar = 'Completed' INSERT INTO Completed(TaskID, TaskName, Description, GETDATE(CompletionDate), Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)

ELSE INSERT INTO IceBox(TaskID, TaskName, Description, CompletionDate, Status, DepartmentID, WorkerAccountID, BusinessAccountID, CreationDate)



-- INDEXES --

CREATE INDEX TopWorker
ON EmployeeTaskCompleteionReview (WorkerAccountID, Name, TaskCount)
ORDER BY DESC;

CREATE INDEX TopWorkerTaskCreations
ON TaskList (WorkerAccountID, Name, TaskCreationCount)
JOIN TaskList ON WorkerAccounts
WHERE TaskList.WorkerAccountID = WorkerAccounts.WorkerAccountID
ORDER BY DESC;

-- INSERTS --

INSERT INTO BusinessAccounts VALUES
(1, 'Garment Tech', '121 Randall Mill Drive', 'Lagrange', 60172, 508-540-6742),
(2, 'Avid Tech', '645 Hudson Rd.', 'Downingtown', 14424, 806-440-7650),
(3, 'Artificial Tech', '801 Lookout Lane', 'Revere', 11377, 208-469-3122),
(4, 'Squared Shop', '7845 Old 53rd Drive', 'Monsey', 33160, 720-293-4404);

INSERT INTO WorkerAccounts VALUES
(1, 'Roberta', 'Future Tactics Specialist', '2amine@acmta.com', 662-237-7348, ,),
(2, 'Sarah', 'Human Resonance Representative', 'wsevdam35-55x@acmta.com', 870-324-9552, ,),
(3, 'Eugene', 'Customer Infrastructure Producer', 'omahmad19r@policity.ml', 330-305-4924, ,),
(4, 'Jacob', 'Legacy Identity Technician', 'vridwan.widanj@bvzoonm.com', 469-414-1852, ,);

INSERT INTO Administrators VALUES
(1, 152, 'Madelyn', 'Legacy Configuration Analyst', 'vridwan.widanj@bvzoonm.com',574-546-3726 ,2),
(2, 152, 'Rudy', 'Investor Mobility Orchestrator', 'kpietra8@kubeflow.info',708-485-4138 ,2),
(3, 152, 'Patrick', 'National Group Coordinator', 'jhassen_44z@twitchmasters.com',510-540-4372 ,3);

INSERT INTO Departments VALUES
(1, 'Production', 3),
(2, 'Operations', 2),
(3, 'HR', 2),
(4, 'Research and Development', 3),
(5, 'Purchasing', 3),
(6, 'Marketing', 2),
(7, 'Accounting and Finance', 2);

INSERT INTO TaskList VALUES
(1, 'Crocodile Show', 'Attend a Crocodile Show',NULL ,'IceBox' ,4 ,3 , 2),
(2, 'English Bulldog', 'Own an English Bulldog',NULL ,'InProgress' ,1 ,3 , 2),
(3, 'Models of Cars', 'Make Models of Cars',NULL ,'Emergency' ,3 ,3 , 2),
(4, 'Write a Book', 'Write a Book to Each of my Children',NULL ,'Emergency' ,4 ,2 , 2),
(5, 'Cook a Meal', 'Cook a Meal from Every Culture',NULL ,'Testing' ,5 ,1 , 3),
(6, 'Complete a Course', 'Complete a Course in Something',NULL ,'IceBox' ,4 ,4 , 3),
(7, 'Music Video', 'Appear in a Music Video',NULL ,'Emergency' ,4 ,3 , 2),
(8, 'Tornado', 'Chase a Tornado',08-09-2012 ,'Completed' ,7 ,4 , 2),
(9, 'First Aid', 'Learn Basic First Aid',NULL ,'IceBox' ,4 ,3 , 3),
(10, 'Poker', 'Play in a Poker Tournament',NULL ,'InProgress' ,4 ,1 , 2),
(11, 'Mountain', 'Climb a Mountain',NULL ,'IceBox' ,1 ,1 , 2),
(12, 'Riot', 'Participate in a Riot',NULL ,'IceBox' ,4 ,3 , 2),
(13, 'Home Remedies', 'Learn all About Home Remedies',NULL ,'InProgress' ,3 ,3 , 2),
(14, 'Whole Book', 'Read a Whole Book in One Day',NULL ,'Testing' ,7 ,3 , 2),
(15, 'Football Match', 'See a Football Match at the Nou Camp',NULL ,'Testing' ,1 ,3 , 2),
(16, 'Care Less', 'Care Less About What People Think',NULL ,'InProgress' ,1 ,3 , 3),
(17, 'Wig', 'Wear a Wig For a Day',NULL ,'IceBox' ,1 ,3 , 2),
(18, 'Christmas', 'Experience a White Christmas',NULL ,'InProgress' ,6 ,3 , 4),
(19, 'Help', 'Help in a Soup Kitchen',NULL ,'IceBox' ,4 ,3 , 2),
(20, 'Jellyfish', 'Own a Jellyfish Aquarium', NULL ,'IceBox' ,7 ,3 , 3),
(21, 'Inspiration', 'Make a "Wall of Inspiration" in my Room',NULL ,'Testing' ,3 ,2 , 3),
(22, 'Chimpanzee', 'Hang Out With a Chimpanzee',NULL ,'Testing' ,2 ,2 , 2),
(23, 'Catfish', 'Hold a Catfish',08-21-2012 ,'Completed' ,6 ,2 , 2),
(24, 'Muffin', 'Make a Muffin Cake',02-14-2013 ,'Completed' ,7 ,4 , 4),
(25, 'TED', 'Attend a TED Talk',03-02-2013 ,'Completed' ,5 ,2 , 2),
(26, 'Taj Mahal', 'See Taj Mahal',NULL ,'Emergency' ,4 ,3 , 2),
(27, 'Tough Mudder', 'Compete in Tough Mudder',NULL ,'Emergency' ,1 ,2 , 3),
(28, 'Nighter', 'Pull an all Nighter',NULL ,'Emergency' ,3 ,3 , 2);

INSERT INTO EmployeeTaskCompleteionReview VALUES
();

INSERT INTO IceBox VALUES
(1, 'Crocodile Show', 'Attend a Crocodile Show',NULL ,'IceBox' ,4 ,3 , 2),
(6, 'Complete a Course', 'Complete a Course in Something',NULL ,'IceBox' ,4 ,4 , 3),
(9, 'First Aid', 'Learn Basic First Aid',NULL ,'IceBox' ,4 ,3 , 3),
(11, 'Mountain', 'Climb a Mountain',NULL ,'IceBox' ,1 ,1 , 2),
(12, 'Riot', 'Participate in a Riot',NULL ,'IceBox' ,4 ,3 , 2),
(17, 'Wig', 'Wear a Wig For a Day',NULL ,'IceBox' ,1 ,3 , 2),
(19, 'Help', 'Help in a Soup Kitchen',NULL ,'IceBox' ,4 ,3 , 2),
(20, 'Jellyfish', 'Own a Jellyfish Aquarium', NULL ,'IceBox' ,7 ,3 , 3);

INSERT INTO Emergency VALUES
(3, 'Models of Cars', 'Make Models of Cars',NULL ,'Emergency' ,3 ,3 , 2),
(4, 'Write a Book', 'Write a Book to Each of my Children',NULL ,'Emergency' ,4 ,2 , 2),
(7, 'Music Video', 'Appear in a Music Video',NULL ,'Emergency' ,4 ,3 , 2),
(26, 'Taj Mahal', 'See Taj Mahal',NULL ,'Emergency' ,4 ,3 , 2),
(27, 'Tough Mudder', 'Compete in Tough Mudder',NULL ,'Emergency' ,1 ,2 , 3),
(28, 'Nighter', 'Pull an all Nighter',NULL ,'Emergency' ,3 ,3 , 2);

INSERT INTO InProgress VALUES
(2, 'English Bulldog', 'Own an English Bulldog',NULL ,'InProgress' ,1 ,3 , 2),
(10, 'Poker', 'Play in a Poker Tournament',NULL ,'InProgress' ,4 ,1 , 2),
(13, 'Home Remedies', 'Learn all About Home Remedies',NULL ,'InProgress' ,3 ,3 , 2),
(16, 'Care Less', 'Care Less About What People Think',NULL ,'InProgress' ,1 ,3 , 3),
(18, 'Christmas', 'Experience a White Christmas',NULL ,'InProgress' ,6 ,3 , 4);

INSERT INTO Testing VALUES
(5, 'Cook a Meal', 'Cook a Meal from Every Culture',NULL ,'Testing' ,5 ,1 , 3),
(14, 'Whole Book', 'Read a Whole Book in One Day',NULL ,'Testing' ,7 ,3 , 2),
(15, 'Football Match', 'See a Football Match at the Nou Camp',NULL ,'Testing' ,1 ,3 , 2),
(21, 'Inspiration', 'Make a "Wall of Inspiration" in my Room',NULL ,'Testing' ,3 ,2 , 3),
(22, 'Chimpanzee', 'Hang Out With a Chimpanzee',NULL ,'Testing' ,2 ,2 , 2);

INSERT INTO Completed VALUES
(8, 'Tornado', 'Chase a Tornado',08-09-2012 ,'Completed' ,7 ,4 , 2),
(23, 'Catfish', 'Hold a Catfish',08-21-2012 ,'Completed' ,6 ,2 , 2),
(24, 'Muffin', 'Make a Muffin Cake',02-14-2013 ,'Completed' ,7 ,4 , 4),
(25, 'TED', 'Attend a TED Talk',03-02-2013 ,'Completed' ,5 ,2 , 2);
