USE AdventureWorks2022;
GO

DROP VIEW IF EXISTS vwCustomerOrders_Yesterday;
GO

CREATE VIEW vwCustomerOrders_Yesterday AS
SELECT 
    s.Name AS CompanyName,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    pp.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS Total
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
WHERE CAST(soh.OrderDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);

SELECT * FROM vwCustomerOrders;