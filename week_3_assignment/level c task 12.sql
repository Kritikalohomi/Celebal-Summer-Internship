--CREATE THE TABLE JOB_COSTS
CREATE TABLE Job_Costs (
Job_Family VARCHAR(20),
Country VARCHAR(30),
Cost int );

--INSERTING THE DATA INTO THE TABLE JOB_COSTS
INSERT INTO Job_Costs
VALUES('HR','India','30000'),
('HR','International','70000'),
('Engineering','India','50000'),
('engineering','International','100000'),
('Marketing ','India','25000'),
('Marketing','International','75000'),
('Sales','India','60000'),
('Sales','International','80000')

--DISPLAYING THE TABLE 
SELECT * FROM Job_Costs

--QUERY EXECUTION 
SELECT Job_Family,
	SUM(CASE WHEN Country ='India' THEN Cost ELSE 0 END ) AS India_Cost,
	SUM(CASE WHEN Country='International' THEN Cost ELSE 0 END) AS Intl_Cost,
ROUND(
	100* SUM(CASE WHEN Country ='India' THEN Cost ELSE 0 END)/NULLIF(sum(COST),0),2
	) as  India_Percentage,
ROUND(
	100* SUM(CASE WHEN Country ='International' THEN Cost ELSE 0 END )/NULLIF(sum(COST),0),2
	) as Intl_Percentage
from Job_Costs 
group by Job_Family



