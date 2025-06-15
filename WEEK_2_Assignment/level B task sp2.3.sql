USE AdventureWorks2022 ;
go

DROP PROCEDURE IF EXISTS dbo.DeleteOrderDetails;
GO

CREATE PROCEDURE dbo.DeleteOrderDetails
	@SalesOrderID int,
	@ProductID int
AS
BEGIN 
	SET NOCOUNT ON;
	--1. Validate the parameters
	IF NOT EXISTS(
	SELECT 1 
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID=@SalesOrderID AND ProductID=@ProductID
	)
	BEGIN
		PRINT'ERROR: Either the orderID does not exist or this product is not the part of that order';
		RETURN -1;
	END
	--Deleting the matching rows
	BEGIN TRY
		DELETE FROM Sales.SalesOrderDetail
		WHERE SalesOrderID = @SalesOrderID AND ProductID =@ProductID

		PRINT'Order Details Deleted Successfully';

	END TRY
	BEGIN CATCH
		PRINT'Error occured during deletion:'+ERROR_MESSAGE()
		RETURN -1;
	END CATCH
END;
go
--Execution of the STORED PROCEDURE with both the valid and invalid order Details  

-- Case: Valid Order and Product
EXEC dbo.DeleteOrderDetails
    @SalesOrderID = 43659,
    @ProductID = 776

	select * from [Sales].[SalesOrderDetail]

-- Case: Invalid combination
EXEC dbo.DeleteOrderDetails
    @SalesOrderID = 43659,
    @ProductID = 99999;  -- Not part of the order


