use AdventureWorks2022;
go
DROP PROCEDURE IF EXISTS dbo.UpdateOrderDetails;
GO
CREATE PROCEDURE dbo. UpdateOrderDetails
	@SalesOrderID INT,
    @ProductID INT,
    @OrderQty INT = NULL,
    @UnitPrice MONEY = NULL,
    @UnitPriceDiscount FLOAT = NULL

AS 
BEGIN 
	SET NOCOUNT ON;
	DECLARE
		@CurrentQty int,
		@OldQty,
		@AvailableQty,
		@ReorderPoint;
--1. Get the current values 
SELECT 
	@OldQty=OrderQty 
	FROM Sales.SalesOrderDetails 
	WHERE SalesOrderId=@SalesOrderId AND ProductId=@ProductId;

IF @OldQty IS NULL
	BEGIN 
		PRINT 'ERROR : No matching orderdetails found'
		RETURN;
	END
--Get Current Inventory
	SELECT
		@AvailableQty=@Quantity,@ReorderPoint=p.ReoderPoint
		FROM Production.ProductInventory pi 
		JOIN Production.Product p 
		ON Pi.ProductId=P.ProductId
		WHERE pi.ProductId=@ProductId AND pi.LocationId=1;
	IF @AvailableQty IS NULL 
		BEGIN 
		PRINT'ERROR: Inventory not found for product'
		RETURN   
		END;

	