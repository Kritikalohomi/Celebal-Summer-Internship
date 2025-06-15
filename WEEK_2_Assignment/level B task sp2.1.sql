--Creation of PROCEDURE InsertOrderDetails 
USE AdventureWorks2022;
GO

DROP PROCEDURE IF EXISTS dbo.InsertOrderDetails;
GO

CREATE PROCEDURE dbo.InsertOrderDetails
    @SalesOrderID INT,
    @ProductID INT,
    @OrderQty SMALLINT,
    @UnitPrice MONEY = NULL,                 -- Optional
    @UnitPriceDiscount FLOAT = 0,            -- Optional
    @SpecialOfferID INT = 1                  -- Default to 'No Discount'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @AvailableQty INT,
        @ProductUnitPrice MONEY,
        @ReorderPoint INT;

    -- Step 1: Get product price and reorder info
    SELECT 
        @ProductUnitPrice = ListPrice,
        @ReorderPoint = ReorderPoint
    FROM Production.Product
    WHERE ProductID = @ProductID;

    -- Step 2: Check available inventory at LocationID = 1
    SELECT @AvailableQty = Quantity
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID AND LocationID = 1;

    -- Step 3: Validate presence
    IF @ProductUnitPrice IS NULL OR @AvailableQty IS NULL
    BEGIN
        PRINT 'Product or inventory not found.';
        RETURN;
    END

    -- Step 4: Check stock
    IF @OrderQty > @AvailableQty
    BEGIN
        PRINT 'Insufficient stock. Cannot place the order.';
        RETURN;
    END

    -- Step 5: Use default UnitPrice if not provided
    IF @UnitPrice IS NULL
        SET @UnitPrice = @ProductUnitPrice;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 6: Insert Order
        INSERT INTO Sales.SalesOrderDetail (
            SalesOrderID,
            ProductID,
            OrderQty,
            UnitPrice,
            UnitPriceDiscount,
            SpecialOfferID
        )
        VALUES (
            @SalesOrderID,
            @ProductID,
            @OrderQty,
            @UnitPrice,
            @UnitPriceDiscount,
            @SpecialOfferID
        );

        -- Step 7: Confirm Insert
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Failed to place the order. Please try again.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 8: Update Inventory
        UPDATE Production.ProductInventory
        SET Quantity = Quantity - @OrderQty
        WHERE ProductID = @ProductID AND LocationID = 1;

        -- Step 9: Warn if stock is low
        IF (@AvailableQty - @OrderQty) < @ReorderPoint
        BEGIN
            PRINT 'Warning: Stock has dropped below the reorder level.';
        END

        COMMIT TRANSACTION;
        PRINT ' Order inserted and inventory updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Get a valid ProductID with stock
SELECT TOP 1 pi.ProductID, p.Name, pi.Quantity
FROM Production.ProductInventory pi
JOIN Production.Product p ON p.ProductID = pi.ProductID
WHERE pi.LocationID = 1 AND pi.Quantity >= 5;

-- Get a SalesOrderID
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderHeader;

EXEC dbo.InsertOrderDetails
    @SalesOrderID = 43659,
    @ProductID = 805,
    @OrderQty = 2;  -- UnitPrice and Discount will be  default