--CREATION OF THE TABLE EMPLOYEES
CREATE TABLE Employees(
Employee_ID int,
Name Varchar(20), 
Sub_Band Varchar(30)
);

--INSERTION OF DATA IN THE TABLE EMPLOYEES
INSERT INTO Employees
Values(1,'Asha','SB1'),
(2,'Rohit','SB2'),
(3,'Neha','SB1'),
(4,'Karan','SB3'),
(5,'Meera','SB2'),
(6,'Sanjay','SB2');

--DISPLAYING THE TABLE 
SELECT * FROM Employees;

--QUERY EXECUTION 
SELECT 
  Sub_Band,
  COUNT(*) AS Headcount,
  ROUND(100.0 * COUNT(*) * 1.0 / COUNT(*) OVER(), 2) AS Percentage_Of_Total
FROM Employees
GROUP BY Sub_Band
ORDER BY Sub_Band;

