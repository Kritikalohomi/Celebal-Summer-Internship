--Creation of the table DimDate
CREATE TABLE DimDate(
	SkDate INT primary Key,
	KeyDate date,
	CalenderDay INT,
	CalenderMonth INT,
	CalenderQuarter INT,
	CalenderYear INT,
	DayNameLong VARCHAR(20),
	DayNameShort VARCHAR(5),
	DayNumberOfWeek INT,
	DayNumberOfYear INT,
	DaySuffix VARCHAR(5),
	FiscalWeek INT ,
	FiscalPeriod INT,
	FiscalQuarter INT,
	FiscalYear INT,
	FiscalYearPeriod VARCHAR(10),
	[Date] DATE,

	);
	
--CREATION OF THE STORED PROCEDURE proc_PopulateDimDateClean
CREATE OR ALTER PROCEDURE proc_PopulateDimDateClean
    @InputDate DATE 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE	
        @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1),
        @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);

    -- Recursive CTE to generate all dates for the year
    ;WITH DateCTE AS (
        SELECT @StartDate AS Dt
        UNION ALL 
        SELECT DATEADD(DAY, 1, Dt)
        FROM DateCTE 
        WHERE Dt < @EndDate
    )
    
    INSERT INTO dbo.DimDate (
        SKDate, KeyDate, CalenderDay, CalenderMonth, 
        CalenderQuarter, CalenderYear, DayNameLong,
        DayNameShort, DayNumberOfWeek, DayNumberOfYear,
        DaySuffix, FiscalWeek, FiscalPeriod, 
        FiscalQuarter, FiscalYear, FiscalYearPeriod, [Date]
    )
    SELECT 
        -- Surrogate Key Date (yyyymmdd as INT)
        CAST(CONVERT(CHAR(8), Dt, 112) AS INT) as SKDate,

        -- KeyDate
        Dt AS KeyDate,

        -- Calendar info
        DAY(Dt) AS CalenderDay,
        MONTH(Dt) AS CalenderMonth,
        DATEPART(QUARTER, Dt) AS CalenderQuarter,
        YEAR(Dt) AS CalenderYear,

        -- Day names
        DATENAME(WEEKDAY, Dt) AS DayNameLong,
        LEFT(DATENAME(WEEKDAY, Dt), 3) AS DayNameShort,

        -- Day numbers
        DATEPART(WEEKDAY, Dt) AS DayNumberOfWeek,
        DATEPART(DAYOFYEAR, Dt) AS DayNumberOfYear,

        -- Suffix
        CASE
            WHEN DAY(Dt) IN (1, 21, 31) THEN 'st'
            WHEN DAY(Dt) IN (2, 22) THEN 'nd'
            WHEN DAY(Dt) IN (3, 23) THEN 'rd'
            ELSE 'th'
        END AS DaySuffix,

        -- Fiscal Week column
        DATEDIFF(WEEK, DATEFROMPARTS(
            CASE 
                WHEN MONTH(Dt) >= 4 THEN YEAR(Dt)
                ELSE YEAR(Dt) - 1
            END, 4, 1), DATEADD(DAY, 1, Dt)) AS FiscalWeek,

        -- Fiscal Period
        CASE 
            WHEN MONTH(Dt) >= 4 THEN MONTH(Dt) - 3
            ELSE MONTH(Dt) + 9
        END AS FiscalPeriod,

        -- Fiscal Quarter
        CASE 
            WHEN MONTH(Dt) BETWEEN 4 AND 6 THEN 1
            WHEN MONTH(Dt) BETWEEN 7 AND 9 THEN 2
            WHEN MONTH(Dt) BETWEEN 10 AND 12 THEN 3
            ELSE 4
        END AS FiscalQuarter,

        -- Fiscal Year
        CASE 
            WHEN MONTH(Dt) >= 4 THEN YEAR(Dt)
            ELSE YEAR(Dt) - 1
        END AS FiscalYear,

        -- Fiscal Year Period
        CONCAT(
            CASE 
                WHEN MONTH(Dt) >= 4 THEN YEAR(Dt)
                ELSE YEAR(Dt) - 1
            END,
            CASE 
                WHEN MONTH(Dt) BETWEEN 4 AND 6 THEN 1
                WHEN MONTH(Dt) BETWEEN 7 AND 9 THEN 2
                WHEN MONTH(Dt) BETWEEN 10 AND 12 THEN 3
                ELSE 4 
            END
        ) AS FiscalYearPeriod,

        -- Raw Date again
        Dt as [Date]

    FROM DateCTE
    OPTION (MAXRECURSION 366);
	
END;

--EXECUTION OF THE STORED PROCEDURE proc_PopulateDimDateClean 
EXEC proc_PopulateDimDateClean '2020-07-14';

--SHOWING THE DATA
select * from dimdate
