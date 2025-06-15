USE AdventureWorks2022;
GO
DROP Procedure IF EXISTS dbo.GetOrderDetails
GO
 CREATE PROCEDURE GetOrderDetails
	@SalesOrderID int
AS
BEGIN 
	SET NOCOUNT ON;
--1. check if the record exists for the given SalesOrderID
IF NOT EXISTS(
	SELECT 1 
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID=@SalesOrderID
	)
	BEGIN
		PRINT'The OrderID doesnot exist'
		RETURN 1;
END
--2. Show the details of the vail SalesOrderID
	SELECT * 
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID=@SalesOrderID

END;
go


--executing the STORED PROCEDURE dbo.GetOrderDetails

--valid SalesOrderiD
EXEC dbo.GetOrderDetails
@salesOrderID=43659


--invalid SalesOrderID
EXEC dbo.GetOrderDetails
@salesOrderID=1111 