----------------------------------|
----- STORED PROCEDURES FILE -----|
----------------------------------|


----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_CREATENEWACCOUNT
------------------------------------------------------------------------------
CREATE OR ALTER PROC proc_createnewaccount
	@FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @DateOfBirth DATE,
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @Address VARCHAR(100),
    @TaxIdentifier VARCHAR(20),

    @CustomerType VARCHAR(20),
    @AadhaarNumber CHAR(12),
    @PANNumber CHAR(10),

    @BranchID INT,
    @AccountNumber VARCHAR(20),
    @AccountType VARCHAR(20),
    @CurrentBalance DECIMAL(10,2),
    @AccountStatus VARCHAR(20) = 'Active',

    @NewPersonID INT OUTPUT,
    @NewCustomerID INT OUTPUT,
    @NewAccountID INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			BEGIN TRANSACTION;

		--Aadhaar Validation 
			IF LEN(@AadhaarNumber)<>12 or @AadhaarNumber LIKE '%[^0-9]%'
			BEGIN
				RAISERROR('Invalid Aadhar Number, must be 12-digit numeric',16,1);
				ROLLBACK TRAN;
				RETURN;
			END
		--PAN Validation
			IF LEN(@PANNumber)<>10
			BEGIN
				RAISERROR('Invalid PAN Number, must be 10 Character',16,1);
				ROLLBACK TRAN;
				RETURN;
			END
		--check if Aadhar number or PAN number already exists
			IF exists (select 1 from customer where AadhaarNumber=@AadhaarNumber OR
				PANNumber=@PANNumber)
			BEGIN
				RAISERROR('Customer with same aadhar number or PAN number already exists',16,1);	
				ROLLBACK TRAN;
				RETURN;
			END

		--insert into person table 
		INSERT INTO Person(
			  FirstName, LastName, DateOfBirth, email, PhoneNumber,
			Address, TaxIdentifier, AadhaarNumber, PANNumber)
		values 
			(@FirstName, @LastName, @DateOfBirth, @email, @PhoneNumber,
			@Address, @TaxIdentifier,@AadhaarNumber, @PANNumber)
		--FETCH the identity(auto- generated)
		set @newpersonid=SCOPE_IDENTITY();

		--Insert into table customer
		INSERT INTO Customer(
			PersonID, CustomerType)
		VALUES
			(@NewPersonID, @CustomerType)
		
		--FETCH the identity(auto-generaated)
		SET @NewCustomerID=SCOPE_IDENTITY();

		--insert into account
		INSERT INTO Account(
			CustomerID, BranchID,AccountNumber, AccountType,
			CurrentBalance,DateOpened, DateClosed, AccountStatus)
		VALUES
			(@NewCustomerID, @BranchID, @AccountNumber,@AccountType,
			@CurrentBalance, GETDATE(), NULL,@AccountStatus)
		
		--FETCH the identity (auto-generated)
		SET @NewAccountID=SCOPE_IDENTITY();

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE();
		RAISERROR(@ErrMsg, 16,1);
	END CATCH
END

--EXECUTION OF THE STORED PROCEDURE 
DECLARE 
    @NewPersonID INT,
    @NewCustomerID INT,
    @NewAccountID INT;

EXEC proc_createnewaccount
    @FirstName = 'Hema',
    @LastName = 'Soni',
    @DateOfBirth = '1997-08-02',
    @Email = 'hemasoni@eg.com',
    @PhoneNumber = '9876756233',
    @Address = '167 Gumanpura, Kota',
    @TaxIdentifier = 'TAX127293N',

    @CustomerType = 'Individual',
    @AadhaarNumber = '122506782638',
    @PANNumber = 'AGRDE7834F',

    @BranchID = 1,  -- Ensure this branch ID exists in your Branch table
    @AccountNumber = 'SB10023456',
    @AccountType = 'Savings',
    @CurrentBalance = 28000.00,
    @AccountStatus = 'Active',

    @NewPersonID = @NewPersonID OUTPUT,
    @NewCustomerID = @NewCustomerID OUTPUT,
    @NewAccountID = @NewAccountID OUTPUT;

-- View the inserted IDs (optional)
SELECT 
    @NewPersonID AS PersonID, 
    @NewCustomerID AS CustomerID, 
    @NewAccountID AS AccountID;


--SHOWING THE RECORDS OF TABLES 
	select * from person 
	select * from Account
	select * from Customer

----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_DEPOSITAMOUNT
------------------------------------------------------------------------------

CREATE or alter PROC proc_DepositAmount
	@Amount decimal(10,2),
	@AccountID int,
	@Remarks VARCHAR(1000)=NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION 
			--checking if the account exists
			IF NOT EXISTS(
				SELECT 1 FROM Account
				WHERE AccountID=@AccountID AND AccountStatus='Active')
			BEGIN
				PRINT('Account doesnot exists or is not active')
				ROLLBACK TRANSACTION ;
				RETURN;
			END
			
			--Insert the deposit transaction
			INSERT INTO [Transaction] (
				AccountID, Transactiontype, Amount, TransactionDate,REMARKS) 
			VALUES 
				(@AccountID, 'Deposit',@Amount,GETDATE(),@Remarks)

			--update the table account
			UPDATE Account 
			SET 
				CurrentBalance=CurrentBalance+@Amount
			WHERE
				AccountID=@AccountID
			
			COMMIT
			PRINT'Deposit successful.'
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;

			DECLARE @ErrMsg VARCHAR(4000)=ERROR_MESSAGE();
			RAISERROR(@ErrMsg,16,1);
		END CATCH
END

--EXECUTION OF THE STORED PROCEDURE proc_DepositAmount
exec proc_DepositAmount @Amount=1200.50, @AccountID =2, 
@Remarks ='Deposited for savings only';

--reviewing the changes on the table 
select * from [Transaction]
select * from account

----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_WITHDRAWALAMOUNT
------------------------------------------------------------------------------

CREATE or alter PROC proc_withdrawalAmount
	@Amount decimal(10,2),
	@AccountID int,
	@Remarks VARCHAR(1000)=NULL
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION 
			--checking if the account exists
			IF NOT EXISTS(
				SELECT 1 FROM Account
				WHERE AccountID=@AccountID AND AccountStatus='Active')
			BEGIN
				PRINT('Account doesnot exists or is not active')
				ROLLBACK TRANSACTION ;
				RETURN;
			END
			
			--Insert the deposit transaction
			INSERT INTO [Transaction] (
				AccountID, Transactiontype, Amount, TransactionDate,REMARKS) 
			VALUES 
				(@AccountID, 'Withdrawal',@Amount,GETDATE(),@Remarks)

			--check if the acccount have sufficient balance 
			IF NOT EXISTS (
				SELECT 1 FROM Account WHERE AccountID=@AccountID and 
				AccountStatus='active' and CurrentBalance>=@Amount)
			BEGIN
				RAISERROR('Insufficient Balance.',16,1)
				ROLLBACK TRANSACTION;
				RETURN
			END

			--update the table account
			UPDATE Account 
			SET 
				CurrentBalance=CurrentBalance-@Amount
			WHERE
				AccountID=@AccountID
			
			COMMIT
			PRINT'Withdrawal successful.'
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;

			DECLARE @ErrMsg VARCHAR(4000)=ERROR_MESSAGE();
			RAISERROR(@ErrMsg,16,1);
		END CATCH
END

--EXECUTION OF THE STORED PROCEDURE proc_WAmount
exec proc_withdrawalAmount @Amount=1000.50, @AccountID =3, 
@Remarks ='Withdrawal for fees';


----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_TRANSFERAMOUNT
------------------------------------------------------------------------------
CREATE PROC proc_TransferAmount
	@FromAccountID int,
	@ToAccountID int,
	@Amount decimal(10,2),
	@Remarks VARCHAR(4000)=NULL
AS
BEGIN
	SET NOCOUNT ON;
	--VALIDATE THE SENDER ACCOUNTS
	IF NOT EXISTS (
		SELECT 1 FROM Account WHERE AccountID=@FromAccountID
		AND AccountStatus='Active')
	BEGIN 
		PRINT 'Sender Account Doesnot exists or i not active. '
		RETURN;
	END

	--VALIDATE THE RECEIVER ACCOUNTS
	IF NOT EXISTS (
		SELECT 1 FROM Account WHERE AccountID=@ToAccountID
		AND AccountStatus='Active')
	BEGIN 
		PRINT 'Receiver Account Doesnot exists or i not active.'	 
		RETURN;
	END
	--check if the sender have sufficient balance
	IF NOT EXISTS (
		SELECT 1 FROM Account WHERE CurrentBalance>=@amount and
		AccountStatus='Active')
	BEGIN 
		PRINT'Sender have insufficient Amount'
		RETURN;
	END

	--Start the transaction
	BEGIN TRY
		BEGIN TRANSACTION 

		--START with deducting from SENDER
		UPDATE Account
		SET
			CurrentBalance=CurrentBalance-@Amount
		WHERE	
			AccountID=@FromAccountID;

		--add amount to receiver
		UPDATE Account
		SET 
			CurrentBalance=CurrentBalance+@Amount
		WHERE
			AccountID=@ToAccountID;

		--add transaction details for sender
		INSERT INTO [Transaction](
			AccountID, TransactionType, Amount, TransactionDate, REMARKS)
		VALUES 
			(@FromAccountID, 'Transfer Out', @Amount, GETDATE(), @Remarks)

		--add transaction details for receiver
		INSERT INTO [Transaction](
			AccountID, TransactionType, Amount, TransactionDate, REMARKS)
		VALUES 
			(@ToAccountID, 'Transfer In', @Amount, GETDATE(), @Remarks)
		
		--COMMIT the transaction 
		COMMIT;
		Print'Transfer Successful.';
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;

		DECLARE @ErrMsg VARCHAR(4000)=ERROR_MESSAGE()
		RAISERROR(@ErrMsg,16,1)	
		
		RETURN;
	END CATCH
END;	

--EXECUTION OF THE STORED PROCEDURE proc_TransferAmount
EXEC
	proc_TransferAmount @FromAccountId = 1, @ToAccountID=2, 
	@Amount =500, @Remarks='school fees '

----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_CLOSEACCOUNT
------------------------------------------------------------------------------

CREATE or alter PROC proc_closeAccount
	@AccountID int,
	@Remarks VARCHAR(4000)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
			--CHECK IF THE ACCOUNT EXISTS
			IF NOT EXISTS(
				SELECT 1 FROM Account WHERE AccountID=@AccountID
				and AccountStatus='Active')
			BEGIN 
				PRINT'Account doesnot exist or is already closed.'
				ROLLBACK;
				RETURN;
			END

			--UPDATE THE ACCOUNT STATUS AND SET THE CLOSEDDATE
			UPDATE Account
			SET
				AccountStatus='Closed'
				, DateClosed = getdate()
			Where
				AccountID=@AccountID
			
			--record a transaction remark for closure 
			INSERT INTO [TRANSACTION](
				AccountID, TransactionType, Amount, Remarks)
			VALUES 
				(@AccountID, 'Account Closed',0.01, @Remarks);

			COMMIT;
			PRINT'Account Successfully CLOSED';
		END TRY
		BEGIN CATCH
			ROLLBACK ;
			DECLARE @ErrMsg VARCHAR(4000)=ERROR_MESSAGE();
			RAISERROR(@ErrMsg,16,1);
			return;
		END CATCH;
END;

--EXECUTION OF THE STORED PROCEDURE proc_closeAccount
exec proc_closeAccount
@AccountID=2, @Remarks='Transfer'


--reviewing the changes on the table 
select * from [Transaction]
select * from account

----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_CLOSEACCOUNT
------------------------------------------------------------------------------

CREATE PROCEDURE proc_CreateNewEmployee
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @DateOfBirth DATE,
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @Address VARCHAR(100),
    @TaxIdentifier VARCHAR(20),
    @AadhaarNumber CHAR(12),
    @PANNumber CHAR(10),
    @Position VARCHAR(20),
    @Salary DECIMAL(10, 2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if this Aadhaar or PAN already exists in Person
        DECLARE @PersonID INT;

        SELECT @PersonID = PersonID
        FROM Person
        WHERE AadhaarNumber = @AadhaarNumber OR PANNumber = @PANNumber;

        --If not exists, insert into Person
        IF @PersonID IS NULL
        BEGIN
            INSERT INTO Person (
                FirstName, LastName, DateOfBirth, Email,
                PhoneNumber, Address, TaxIdentifier,
                AadhaarNumber, PANNumber
            )
            VALUES (
                @FirstName, @LastName, @DateOfBirth, @Email,
                @PhoneNumber, @Address, @TaxIdentifier,
                @AadhaarNumber, @PANNumber
            );

            SET @PersonID = SCOPE_IDENTITY(); -- Get new PersonID
        END

        --Check if this PersonID is already an employee
        IF EXISTS (
            SELECT 1 FROM Employee WHERE PersonID = @PersonID
        )
        BEGIN
            RAISERROR('This person is already an employee.', 16, 1);
            ROLLBACK;
            RETURN;
        END

        --Insert into Employee
        INSERT INTO Employee (PersonID, Position, Salary)
        VALUES (@PersonID, @Position, @Salary);

        COMMIT;
        PRINT 'New employee created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @Err VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Err, 16, 1);
    END CATCH
END;

--execution code for stored procedure proc_CreateNewEmployee
EXEC proc_CreateNewEmployee
    @FirstName = 'Ankita',
    @LastName = 'Mumtani',
    @DateOfBirth = '1994-07-15',
    @Email = 'ankitam@eg.com',
    @PhoneNumber = '9876546427',
    @Address = 'Jaipur, Rajasthan',
    @TaxIdentifier = 'TAX096627IND',
    @AadhaarNumber = '783412328410',
    @PANNumber = 'HDPKM1834T',
    @Position = 'Relationship Manager',
    @Salary = 66000.00;


----------------------------------------------------------------------------
--CREATION OF THE STORED PROCEDURE PROC_VIEWTRANSACTIONHISTORY
------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE proc_ViewTransactionHistory
    @AccountID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if account exists
    IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountID = @AccountID)
    BEGIN
        PRINT 'Account does not exist.';
        RETURN;
    END

    --Show account + person info
    SELECT 
        A.AccountID,
        P.FirstName,
        P.LastName,
        A.AccountNumber,
        A.AccountType,
        A.CurrentBalance
    FROM Account A
    JOIN Customer C ON A.CustomerID = C.CustomerID
    JOIN Person P ON C.PersonID = P.PersonID
    WHERE A.AccountID = @AccountID;

    --Show last 10 transactions (if any)
    IF EXISTS (SELECT 1 FROM [Transaction] WHERE AccountID = @AccountID)
    BEGIN
        SELECT TOP 10
            T.TransactionID,
            T.TransactionType,
            T.Amount,
            T.TransactionDate,
            T.Remarks
        FROM [Transaction] T
        WHERE T.AccountID = @AccountID
        ORDER BY T.TransactionDate DESC;
    END
    ELSE
    BEGIN
        PRINT 'No transactions have been made yet on this account.';
    END
END
GO


--EXECUTION OF THE STORED PROCEDURE 
EXEC proc_ViewTransactionHistory @AccountID=1;

