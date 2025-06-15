
CREATE TRIGGER trg_DeleteOrderCascade
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    --1. Delete from Order Details for the order(s) being deleted
    DELETE FROM [Order Details]
    WHERE OrderID IN (SELECT OrderID FROM DELETED);

    --2. Delete from Orders table
    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM DELETED);
END;

USE Northwind;
GO
