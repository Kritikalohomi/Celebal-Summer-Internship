USE AdventureWorks2022;
GO

DROP VIEW IF EXISTS vwCustomerOrders;
GO

CREATE VIEW vwCustomerOrders AS
SELECT 
    s.Name AS CompanyName,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS Total
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c 
	ON soh.CustomerID = c.CustomerID
JOIN Sales.Store s 
	ON c.StoreID = s.BusinessEntityID
JOIN Sales.SalesOrderDetail sod 
	ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p 
	ON sod.ProductID = p.ProductID;

	SELECT * FROM vwCustomerOrders;