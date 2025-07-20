--Creation of the TABLE DimCustomer
CREATE TABLE DimCustomer(
CustomerID INT Primary Key,
Name VARCHAR(100),
DOB DATE,
Email NVARCHAR(100),
City NVARCHAR(100),
PreviousCity NVARCHAR(100),
EffectiveDate DateTime,
ExpiryDate Datetime,
IsCurrent BIT Default 1,
LastUpdated DateTime
);

--Creation of the TABLE DimCustomer1 for SCD type 4 
CREATE TABLE DimCustomer1(
CustomerID INT Primary Key,
Name VARCHAR(100),
DOB DATE,
Email NVARCHAR(100),
City NVARCHAR(100),
EffectiveDate DateTime,
LastUpdated DateTime
);


--Creation of the table stgCustomer
CREATE TABLE StgCustomer(
CustomerID INT ,
Name NVARCHAR(100),
DOB Date ,
Email NVARCHAR(100),
City NVARCHAR(100),
);
drop table DimCustomerHistory
--Creation of the table DimCustomerHistory
CREATE TABLE DimCustomerHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    Name NVARCHAR(100),
    DOB DATE,
    Email NVARCHAR(100),
    City NVARCHAR(100),
    ArchivedDate DATETIME
);
select * from dimcustomerhistory


--insertion of data into table DimCustomer
INSERT INTO DimCustomer
VALUES (101,'Kritika','2002-07-08','kritika@gmail.com','Kota',NULL,'2025-02-02',NULL,1,'2025-02-02'),

(102,'Amit','2002-09-18','amit@gmail.com','Jaipur',NULL,'2025-02-04',NULL,1,'2025-02-04'),
(103,'Piyal','2002-03-14','piyal@gmail.com','Delhi',NULL,'2025-02-05',NULL,1,'2025-02-05'),
(104,'Vinod','2004-01-05','vinod@gmail.com','Bundi',NULL,'2025-02-06',NULL,1,'2025-02-06'),
(105,'Mohit','2006-06-15','mohit@gmail.com','Amritsar',NULL,'2025-02-07',NULL,1,'2025-02-07')
;

--insertion of data into the table DimCustomer1 for SCD type 4
INSERT INTO DimCustomer1
VALUES (101,'Kritika','2002-07-08','kritika@gmail.com','Kota',getdate(),getdate()),
(102,'Amit','2002-09-18','amit@gmail.com','Jaipur',getdate(),getdate()),
(103,'Piyal','2002-03-14','piyal@gmail.com','Delhi',getdate(),getdate()),
(104,'Vinod','2004-01-05','vinod@gmail.com','Bundi',getdate(),getdate()),
(105,'Mohit','2006-06-15','mohit@gmail.com','Amritsar',getdate(),getdate())
;

--Insertion of data into the table StgCustomer
INSERT INTO StgCustomer
VALUES(103,'Piyal','2002-03-14','piyal@gmail.com','Kota');

--Creation of Stored Procedure for SCD Type 0
CREATE PROCEDURE SCD_type_0
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO DimCustomer(CustomerID, Name, DOB, Email, City,PreviousCity, EffectiveDate, ExpiryDate, IsCurrent, LastUpdated)
	select s.CustomerID,s.Name, s.DOB, s.Email, s.City, NULL, GETDATE(),NULL,1, GETDATE()
	FROM StgCustomer s
		WHERE NOT EXISTS (
							select 1
							From DimCustomer d
							WHERE d.CustomerID=s.CustomerID
						);
END


--Execution of the stored procedure for SCD type 0
exec SCD_type_0;

--showing the changes in the tables DimCustomer
Select * from  DimCustomer

--Creation of the Stored Procedure for SCD type 1
CREATE PROCEDURE scd_type_1
AS
BEGIN
	set nocount on;
	--update the existing customer where any changes occur
	UPDATE d
	SET d.Name=s.Name, d.DOB=s.DOB, d.Email=s.Email,d.City=s.City,
	d.LastUpdated=getdate()
	from DimCustomer d
	JOIN StgCustomer s
	on d.Customerid=s.CustomerID
	WHERE
		( d.Name<>s.Name or d.DOB<>s.DOB or d.Email<>s.Email or d.City<>s.City);

	--insert new customers 
	INSERT INTO DimCustomer(
	 CustomerID, Name, DOB, Email, City,PreviousCity,
	 EffectiveDate, ExpiryDate, IsCurrent, LastUpdated)
	 select s.Customerid, s.Name, s.DOB, s.Email, s.City,NULL,
	 getdate(), null, 1,getdate()
	 from StgCustomer s
	 Where not exists (
		select 1
		from dimcustomer d
		where d.customerid=s.customerid
		);
END
		
--Execution of the stored procedure for SCD type 1
exec scd_type_1;

--Creation of the stored procedure for scd type 2
CREATE PROC SCD_type_2
AS
BEGIN

--expiring the existing records where changes occured
	UPDATE d
	SET 
	d.expirydate=getdate(),
	d.iscurrent=0,
	d.lastupdated=getdate()
	From DimCustomer d
	join StgCustomer s
	on d.customerid=s.customerid
	where
	d.IsCurrent=1 and
	(d.Name <> s.Name OR
     d.DOB <> s.DOB OR
     d.Email <> s.Email OR
     d.City <> s.City);
	
--inserting the new version of the changed or new customer
	insert into DimCustomer(
	CustomerID, Name, DOB, Email, City,
    PreviousCity, EffectiveDate, ExpiryDate, IsCurrent, LastUpdated
    )
	select s.CustomerID, s.Name,s.DOB,s.Email, s.City,
	NULL, GETDATE(), NULL, 1, getdate()
	FROM StgCustomer s
	left join DimCustomer d
	on d.customerid=s.customerid and iscurrent=1
	where
		d.Customerid is null or
		d.name<>s.name or
	    d.DOB <> s.DOB OR
        d.Email <> s.Email OR
        d.City <> s.City;

END

--execution of the stored procedure scd_type_2
exec SCD_type_2;

--Creation of the stored procedure for SCD type 3
CREATE PROC SCD_type_3
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO DimCustomer(
	  CustomerID, Name, DOB, Email, City,
      PreviousCity, EffectiveDate, ExpiryDate,
      IsCurrent, LastUpdated)

	  select s.Customerid, s.name,s.DOB, s.Email, s.City, null
	  , GETDATE(),NULL, 1,GETDATE()
	  FROM StgCustomer s
	  LEFT JOIN DimCustomer d 
	  on s.Customerid= d.Customerid
	  WHERE d.Customerid is null;
--Update the city if required 
UPDATE d
SET d.previouscity=d.city,
	d.city=s.city,
	d.lastupdated=getdate()

	from DimCustomer d
	join StgCustomer s 
	on d.CustomerID=s.CustomerID
	WHERE
		s.city<>d.city
		and iscurrent=1
END;

--execution of the stored procedure for scd type 3
exec SCD_type_3;

--creation of stored procedure for SCD type 4
ALTER PROCEDURE SCD_type_4
AS
BEGIN
    SET NOCOUNT ON;

    --1: Insert new customers
    INSERT INTO DimCustomer1 (
        CustomerID, Name, DOB, Email, City,
        EffectiveDate, LastUpdated
    )
    SELECT 
        s.CustomerID, s.Name, s.DOB, s.Email, s.City,
        GETDATE(), GETDATE()
    FROM StgCustomer s
    LEFT JOIN DimCustomer1 d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;

    --2: Archive changed records
    INSERT INTO DimCustomerHistory (
        CustomerID, Name, DOB, Email, City, ArchivedDate
    )
    SELECT 
        d.CustomerID, d.Name, d.DOB, d.Email, d.City, GETDATE()
    FROM DimCustomer1 d
    JOIN StgCustomer s ON d.CustomerID = s.CustomerID
    WHERE 
        ISNULL(d.Name, '') <> ISNULL(s.Name, '') OR
        ISNULL(d.DOB, '1900-01-01') <> ISNULL(s.DOB, '1900-01-01') OR
        ISNULL(d.Email, '') <> ISNULL(s.Email, '') OR
        ISNULL(d.City, '') <> ISNULL(s.City, '');

    --3: Update changed records
    UPDATE d
    SET 
        d.Name = s.Name,
        d.DOB = s.DOB,
        d.Email = s.Email,
        d.City = s.City,
        d.LastUpdated = GETDATE()
    FROM DimCustomer1 d
    JOIN StgCustomer s ON d.CustomerID = s.CustomerID
    WHERE 
        ISNULL(d.Name, '') <> ISNULL(s.Name, '') OR
        ISNULL(d.DOB, '1900-01-01') <> ISNULL(s.DOB, '1900-01-01') OR
        ISNULL(d.Email, '') <> ISNULL(s.Email, '') OR
        ISNULL(d.City, '') <> ISNULL(s.City, '');
		 DELETE FROM StgCustomer;

END;



--execution of the stored procedure for SCD type 4
exec SCD_type_4

select * from dimcustomer
select * from stgcustomer
select * from DimCustomerHistory

--creation of the Stored procedure for SCD type 6
CREATE or alter PROC SCD_type_6
AS
BEGIN
	SET NOCOUNT ON;
	--insertion of new customer 
	INSERT INTO DimCustomer(
		CustomerID, Name, DOB, Email, City,
		PreviousCity, EffectiveDate, ExpiryDate,
		IsCurrent, LastUpdated
	)
	SELECT
		s.CustomerID, s.Name, s.DOB, s.Email, s.City,
        NULL, GETDATE(), NULL, 1, GETDATE()
	FROM
		StgCustomer s
	LEFT JOIN 
		DimCustomer d
	ON
		s.CustomerID=d.CustomerID and d.IsCurrent=1
	WHERE 
		d.CustomerID is NULL;
--create a CTE that hold the changed records 
	WITH changed as(
	select d.*
	from DimCustomer d
	join stgcustomer s
	on s.customerid=d.customerid 
	where d.iscurrent =1
	and (ISNULL(d.Name, '') <> ISNULL(s.Name, '') OR
        ISNULL(d.DOB, '1900-01-01') <> ISNULL(s.DOB, '1900-01-01') OR
        ISNULL(d.Email, '') <> ISNULL(s.Email, '') OR
        ISNULL(d.City, '') <> ISNULL(s.City, ''))
)
--expire the old records 
update d
set 
d.iscurrent=0, d.expirydate=getdate(),d.lastupdated=getdate()
from DimCustomer d
join changed c on d.CustomerID=c.CustomerID and d.iscurrent=1;

--insert new version with updated information and old city as previous city
insert into DimCustomer(
	CustomerID, Name, DOB, Email, City,
    PreviousCity, EffectiveDate, ExpiryDate,
    IsCurrent, LastUpdated)
select 
	s.customerid, s.Name,s.DOB, s.Email,s.City, d.city, GETDATE(),
	NULL, 1,GETDATE()
FROM
	stgCustomer s
	join DimCustomer d
	on d.CustomerID=s.CustomerID
	DELETE FROM StgCustomer;
end

--execution of the stored procedure 
exec SCD_type_6


select * from dimcustomer
select * from stgcustomer

