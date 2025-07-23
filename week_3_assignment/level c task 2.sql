--Creation of TABLE Students
CREATE TABLE Students (
ID int Primary Key,
Name varchar(20));

--Creation of the TABLE Friends
CREATE TABLE Friends (
ID int Primary Key,
Name varchar(20));

--Creation of th TABLE Packages 
CREATE TABLE Packages (
ID int Primary Key,
Salary real),

--Insertion in the TABLE Students
INSERT INTO Students
Values(1,'Ashley'),
(2,'Samantha'),
(3,'Julia'),
(4,'Scarlet')

--Insertion in the TABLE Friends 
INSERT INTO Friends 
Values(1,2),
(2,3),
(3,4),
(4,1)

--Insertion in the TABLE Packages 
INSERT INTO Packages
Values(1,15.20),
(2,10.06),
(3,11.55),
(4,12.12)

--Dsplay all the TABLES
select * from Students 
select * from Friends
select * from Packages

--QUERY for the task
SELECT S.Name 
FROM Students s
JOIN Friends f
ON s.ID=f.ID
JOIN Packages sp
ON s.ID=sp.ID
JOIN Packages fp
ON fp.ID=f.Friend_ID
where sp.Salary<fp.Salary
ORDER BY FP.salary