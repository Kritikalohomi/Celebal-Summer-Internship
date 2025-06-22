--CREATION OF THE TABLE COMPANY
Create table Company(
	Company_Code VARCHAR(30),
	Founder VARCHAR(30)
);

--CREATION OF THE TABLE LEAD_MANAGER
Create Table Lead_Manager(
	Lead_Manager_Code VARCHAR(30),
	Company_Code VARCHAR(30)
);

--CREATION OF NTHE TABLE SENIOR_MANAGER
Create Table Senior_Manager(
	Senior_Manager_Code VARCHAR(30),
	Lead_Manager_Code VARCHAR(30),
	Company_Code VARCHAR(30)
);

--CREATION OF THE TABLE MANAGER
Create Table Manager(
	Manager_Code VARCHAR(30),
	Senior_Manager_Code VARCHAR(30),
	Lead_Manager_Code VARCHAR(30),
	Company_Code VARCHAR(30)
);


--CRREATION OF THE TABLE EMPLOYEE
Create Table Employee (
	Employee_Code VARCHAR(30),
	Manager_Code VARCHAR(30),
	Senior_Manager_Code VARCHAR(30),
	Lead_Manager_Code VARCHAR(30),
	Company_Code VARCHAR(30)
);


--INSERTION IN THE TABLE COMPANY
INSERT INTO Company 
	 VALUES ('C1', 'Monika'),
			('C2','Samantha ')
--INSERTION IN THE TABLE LEAD_MANAGER
INSERT INTO Lead_Manager
	VALUES ('LM1','C1'),
		   ('LM2','C2')
--INSERTION IN THE TABLE SENIOR_MANAGER
INSERT INTO Senior_Manager
	VALUES ('SM1','LM1','C1'),
		   ('SM2','LM1','C1'),
		   ('SM3','LM2','C2')

--INSERTION IN THE TABLE MANAGER
INSERT INTO Manager
	VALUES ('M1','SM1','LM1','C1'),
		   ('M2','SM3','LM2','C2'),
		   ('M3','SM3','LM2','C2')


--INSERTION IN THE TABLE EMPLOYEE
INSERT INTO Employee
	VALUES ('E1','M1','SM1','LM1','C1'),
		   ('E2','M1','SM1','LM1','C1'),
		   ('E3','M2','SM3','LM2','C2'),
		   ('E4','M3','SM3','LM2','C2')

--DISPLAYING IN THE TABLE EMPLOYEE
SELECT * FROM COMPANY
SELECT * FROM LEAD_MANAGER
SELECT * FROM SENIOR_MANAGER
SELECT * FROM MANAGER
SELECT * FROM EMPLOYEE

--QUERY EXECUTION 
SELECT 
	c.Company_Code, c.Founder,COUNT(DISTINCT lm.Lead_Manager_Code) AS Total_Lead_Manager,
	COUNT(DISTINCT sm.Senior_Manager_code) AS Total_Senior_Manager,COUNT(DISTINCT m.Manager_Code) AS Total_Manager
	, COUNT(DISTINCT e.Employee_Code) AS Total_Emoplyee
FROM Company c
LEFT JOIN Lead_Manager lm
	ON c.Company_Code=lm.Company_Code
LEFT JOIN Senior_Manager sm
	ON lm.Lead_Manager_Code=sm.Lead_Manager_code
LEFT JOIN Manager m
	ON sm.Senior_Manager_Code=m.Senior_Manager_Code 
LEFT JOIN Employee e
	ON m.Manager_Code=e.Manager_Code
GROUP BY c.Company_Code, c.Founder
ORDER by c.Company_Code asc