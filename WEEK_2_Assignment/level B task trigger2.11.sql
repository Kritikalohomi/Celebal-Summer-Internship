USE Northwind;
GO
--creation of trg_CheckStockBeforeInsert

CREATE TRIGGER trg_CheckStockBeforeInsert
ON [Order Details]
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for any rows in the INSERT that have insufficient stock
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Products p ON i.ProductID = p.ProductID
        WHERE i.Quantity > p.UnitsInStock
    )
    BEGIN
        PRINT 'Order could not be filled due to insufficient stock.';
        RETURN;
    END

    -- Insert the order details
    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    SELECT OrderID, ProductID, UnitPrice, Quantity, Discount
    FROM INSERTED;

    -- Decrease the stock for each product
    UPDATE p
    SET UnitsInStock = p.UnitsInStock - i.Quantity
    FROM Products p
    JOIN INSERTED i ON i.ProductID = p.ProductID;

    PRINT 'Order inserted successfully and stock updated.';
END;


-- 1. Check current stock
SELECT ProductID, ProductName, UnitsInStock FROM Products WHERE ProductID = 1;

-- 2. Try inserting an order that exceeds stock
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10248, 1, 18.00, 9999, 0.0); -- Should FAIL

-- 3. Try inserting a valid order
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10248, 1, 18.00, 2, 0.0); -- Should SUCCEED
