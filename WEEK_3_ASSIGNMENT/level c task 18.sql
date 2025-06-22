--CREATION OF THE TABLE EMPLOYEE_COSTS
CREATE TABLE Employee_Costs (
    BU_Name NVARCHAR(50),
    Month_Year DATE,
    Headcount INT,
    Cost DECIMAL(10, 2)
);

--INSERTING DATA IN THE TABLE EMPLOYEE_COSTS
INSERT INTO Employee_Costs (BU_Name, Month_Year, Headcount, Cost)
VALUES 
-- January data
('Sales', '2024-01-01', 10, 50000),
('Sales', '2024-01-01', 5, 25000),
('HR',    '2024-01-01', 8, 40000),

-- February data
('Sales', '2024-02-01', 12, 60000),
('HR',    '2024-02-01', 10, 47000),

-- March data
('Sales', '2024-03-01', 15, 75000),
('HR',    '2024-03-01', 9, 45000);

--DIPLAYING THE TABLE DATA
SELECT * FROM Employee_Costs

--QUERY EXECUTION 
SELECT 
    BU_Name,
    FORMAT(Month_Year, 'yyyy-MM') AS Month,
    ROUND(
        1.0 * SUM(Cost * Headcount) / NULLIF(SUM(Headcount), 0), 
        2
    ) AS Weighted_Avg_Cost
FROM Employee_Costs
GROUP BY BU_Name, FORMAT(Month_Year, 'yyyy-MM')
ORDER BY BU_Name, Month;
