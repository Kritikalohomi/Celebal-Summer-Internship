--Create the Table BU_Transactions
CREATE TABLE BU_Transactions(
	BU_Name VARCHAR(50),
	Transaction_Date Date,
	Cost int,
	Revenue int
	);

--Inserting data on the table Transactions 
INSERT INTO BU_Transactions
	VALUES('Sales','2024-01-05',50000,100000),
		('Sales','2024-01-15',50000,100000),
		('IT','2024-01-10',150000,300000),
		('HR','2024-02-03',50000,40000)

--DISPLAYING THE TABLE 
SELECT * FROM BU_transactions

--QUERY EXECUTION 
SELECT BU_Name,
	FORMAT(Transaction_Date, 'yyyy-MM') as Month_Year,
	SUM(Cost) AS Total_Cost,
	SUM(Revenue)AS Total_Revenue,
	ROUND(1.0*sum(cost)/NULLIF(SUM(Revenue),0),2) as Cost_Revenue_Ratio
FROM BU_Transactions 
group by BU_Name, FORMAT(Transaction_date, 'yyyy-MM')
order by BU_Name, Month_Year;

