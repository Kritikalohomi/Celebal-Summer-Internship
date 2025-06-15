USE AdventureWorks2022
GO
DROP FUNCTION IF EXISTS dbo.FormatDateYYYYMMDD
GO

CREATE FUNCTION dbo.FormatDateYYYYMMDD
(
	@InputDate Datetime
)
	RETURNS VARCHAR(10)
AS
BEGIN
	RETURN CONVERT(VARCHAR(10), @Inputdate,111);
END
GO

--Applig the format on the current date
SELECT dbo.FormatDateYYYYMMDD(GETDATE()) AS FormattedDate;
