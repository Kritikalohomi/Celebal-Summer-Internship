--CREATION OF THE TABLE STUDENTS
CREATE TABLE Students (
	ID INT,
	Name VARCHAR(30)
);

--CREATION OF THE TABLE FRIENDS
CREATE TABLE Friends (
	ID INT,
	Friend_ID INT
);

--CREATION OF THE TABLE PACKAGES
CREATE TABLE Packages (
	ID INT,
	Salary real
);

--INSERTING VALUES INTO TABLE STUDENTS
INSERT INTO Students 
	VALUES (1,'Ashley'),
	(2,'Samantha'),
	(3,'Julia'),
	(4,'Scarlet')

--INSERTING INTO TABLE FRIENDS
INSERT INTO Friends 
VALUES (1,2),
		(2,3),
		(3,4),
		(4,1)

--INSERTING INTO TABLE PACKAGES 
INSERT INTO Packages 
VALUES (1,15.20),
(2,10.06),
(3,11.55),
(4,12.12)


--DISPLAYING THE TABLES 
SELECT *  FROM STUDENTS
SELECT * FROM FRIENDS
SELECT * FROM PACKAGES 

--QUERY EXECUTION 
SELECT  s.name, sp.salary,Friend_ID,fp.salary  
FROM Students s
JOIN Friends f
ON s.ID=f.ID
JOIN Packages sp  --Students's Salary
ON F.ID=sp.ID
JOIN Packages fp   -- Friend's Salary
on fp.ID=F.friend_ID
WHERE fp.Salary>sp.Salary
ORDER BY fp.Salary 