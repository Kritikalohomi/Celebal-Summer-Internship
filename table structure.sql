--creation of the table person 
CREATE TABLE [Person] (
  [PersonID] int PRIMARY KEY,
  [FirstName] varchar(100),
  [LastName] varchar(100),
  [DateOfBirth] date,
  [Email] varchar(100),
  [PhoneNumber] varchar(20),
  [Address] varchar(100),
  [TaxIdentifier] varchar(20),
  [AadhaarNumber] char(12) NOT NULL,
  [PANNumber] char(10) NOT NULL
)
GO

--creation of the table customer
CREATE TABLE [Customer] (
  [CustomerID] int PRIMARY KEY,
  [PersonID] int,
  [CustomerType] varchar(20)
)
GO

  


--creation of the table branch
CREATE TABLE [Branch] (
  [BranchID] int PRIMARY KEY,
  [BranchName] varchar(100),
  [BranchCode] varchar(10) UNIQUE,
  [Address] varchar(100),
  [PhoneNumber] varchar(20)
)
GO

--creation of the table account
CREATE TABLE [Account] (
  [AccountID] int PRIMARY KEY,
  [CustomerID] int,
  [BranchID] int,
  [AccountNumber] varchar(20) UNIQUE,
  [AccountType] varchar(20),
  [CurrentBalance] decimal(10,2),
  [DateOpened] date,
  [DateClosed] date,
  [AccountStatus] varchar(20)
)
GO

--creation of the table transaction
CREATE TABLE [Transaction] (
  [TransactionID] int PRIMARY KEY,
  [AccountID] int,
  [TransactionType] varchar(20),
  [Amount] decimal(10,2),
  [TransactionDate] datetime
)
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Must be 12-digit UID',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Customer',
@level2type = N'Column', @level2name = 'AadhaarNumber';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Must be 10-character PAN',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Customer',
@level2type = N'Column', @level2name = 'PANNumber';
GO

--Adding foreign key to the tables 

ALTER TABLE [Customer] ADD FOREIGN KEY ([PersonID]) REFERENCES [Person] ([PersonID])
GO

ALTER TABLE [Employee] ADD FOREIGN KEY ([PersonID]) REFERENCES [Person] ([PersonID])
GO

ALTER TABLE [Account] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([CustomerID])
GO

ALTER TABLE [Account] ADD FOREIGN KEY ([BranchID]) REFERENCES [Branch] ([BranchID])
GO

ALTER TABLE [Transaction] ADD FOREIGN KEY ([AccountID]) REFERENCES [Account] ([AccountID])
GO

--Adding NOT NULL Constraint to esnure data integrity
ALTER TABLE [Person]
ALTER COLUMN [FirstName] VARCHAR(100) NOT NULL;

ALTER TABLE [Person]
ALTER COLUMN [LastName] VARCHAR(100) NOT NULL;

ALTER TABLE [Customer]
ALTER COLUMN [CustomerType] VARCHAR(20) NOT NULL;

ALTER TABLE [Account]
ALTER COLUMN [AccountType] VARCHAR(20) NOT NULL;

ALTER TABLE [Account]
ALTER COLUMN [AccountStatus] VARCHAR(20) NOT NULL;


--Adding CHECK constraint 
ALTER TABLE [Account]
ADD CONSTRAINT chk_balance_positive CHECK (CurrentBalance >= 0);

ALTER TABLE [Transaction]
ADD CONSTRAINT chk_transaction_amount_positive CHECK (Amount > =0);

ALTER TABLE [Person]
ADD CONSTRAINT chk_valid_email CHECK (Email LIKE '_%@_%._%');

--Adding the DEFAULT constraint
ALTER TABLE [Account]
ADD CONSTRAINT df_account_status DEFAULT 'Active' FOR [AccountStatus];

ALTER TABLE [Transaction]
ADD CONSTRAINT df_transaction_date DEFAULT GETDATE() FOR [TransactionDate];

--Adding Dynamic Data Masking
ALTER TABLE Customer
ALTER COLUMN AadhaarNumber CHAR(12) MASKED WITH (FUNCTION = 'partial(0,"XXXX-XXXX-",4)') NOT NULL;

ALTER TABLE Customer
ALTER COLUMN PANNumber CHAR(10) MASKED WITH (FUNCTION = 'partial(0,"XXXX",6)') NOT NULL;

--Inserting data into the table PERSON
INSERT INTO Person(
	PersonID, FirstName, LastName,DateOfBirth, Email,PhoneNumber,
	Address, TaxIdentifier
)
VALUES(1,'Kritika','Lohomi','2001-01-01','kritika@gmail.com','9626279362',
'Kota,Rajasthan','TAX101001'),
(2,'Harsh','Sharma','2001-02-01','harsh@gmail.com','9626276642',
'Jaipur,Rajasthan','TAX101002'),
(3,'Amit','Joshi','2001-03-01','amit@gmail.com','8826279362',
'Delhi','TAX101003'),
(4,'Jash','Pandey','2001-04-01','jash@gmail.com','6326639362',
'Mumbai,Maharashtra','TAX101004'),
(5,'Rohit','Saini','2001-05-07','rohit@gmail.com','7726286736',
'Amritsar,Punjab','TAX101005');

--Inserting data into the table CUSTOMER
INSERT INTO Customer(
	CustomerID, PersonID, CustomerType, AadhaarNumber, PANNumber)
VALUES
	(101,1,'Indiviual','162672712827','AKSHE1865F'),
	(103,3,'Indiviual','366472712898','MJYGE1535F'),
	(105,5,'Indiviual','732672710853','OYSKT1907E');

--INSERTING INTO THE TABLE EMPLOYEE
INSERT INTO Employee(
	EmployeeID, PersonID, Position, Salary)
VALUES
	(1001,2,'Manager',80000.00),
	(1002,4,'Cashier',50000.00);

--INSERTING THE DATA INTO THE TABLE BRANCH
INSERT INTO Branch(
	BranchID, BranchName, BranchCode, Address, PhoneNumber)
VALUES
	(1, 'Rampura ','SBBI001', 'arya samaj, Kota', '1800-2345-678'),
	(2, 'Aerodram ','SBBI002', 'Mohanpura, Kota', '1800-2674-603');

--INSERTING THE DATA INTO THE TABLE ACCOUNT
INSERT INTO Account(
	 CustomerID, BranchID, AccountNumber, AccountType,
	CurrentBalance, DateOpened, DateClosed, AccountStatus)
VALUES
	(101,1,'ACC101101', 'Savings',10000.0, '2024-01-01',NULL, 
	'Active'),
	(103,2,'ACC101102', 'Current',15000.0, '2024-02-03',NULL, 
	'Active'),
	(105,1,'ACC101105', 'Savings',20000.0, '2024-05-06',NULL, 
	'Active');

--INSERTING THE DATA INTO THE TABLE TRANSACTION 
INSERT INTO [Transaction](
	TransactionID, AccountID, TransactionType, Amount, TransactionDate)
VALUES
	(1101, 10001,'Deposit',1000.0, getdate()),
	(1102, 10002,'Withdrawal',1000.0, getdate());

-- View all accounts with branch and customer info
--checking the foreign key constraints 
SELECT a.AccountNumber, a.AccountType, a.CurrentBalance, b.BranchName, p.FirstName AS CustomerName
FROM Account a
JOIN Branch b ON a.BranchID = b.BranchID
JOIN Customer c ON a.CustomerID = c.CustomerID
JOIN Person p ON c.PersonID = p.PersonID;


--reviewing all the tables 
select * from person
select * from customer
select * from Employee
select * from Branch
select * from account
select * from [transaction] 