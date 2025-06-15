USE AdventureWorks2022;
GO

DROP FUNCTION IF EXISTS dbo.FormatDateMMDDYYYY;
GO
--creating a function 
CREATE FUNCTION dbo.FormatDateMMDDYYYY
(
    @InputDate DATETIME
)
RETURNS VARCHAR(10)
AS
BEGIN
    -- Style 101 = mm/dd/yyyy
    RETURN CONVERT(VARCHAR(10), @InputDate, 101);
END;
GO

-- Applying the format at the current date
SELECT dbo.FormatDateMMDDYYYY(GETDATE()) as Formated_date