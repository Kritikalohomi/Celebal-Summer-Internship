--CREATION OF THE TABLE PROJECTS
CREATE TABLE Projects (
Task_ID int ,
Start_Date Date,
End_Date Date
)
--INSERTION OF DATA INTO THE TABLE PROJECTS 
INSERT INTO Projects (Task_ID,Start_Date,End_Date)
VALUES (1,'2015-10-01','2015-10-02'),
(2,'2015-10-02','2015-10-03'),
(3,'2015-10-03','2015-10-04'),
(4,'2015-10-13','2015-10-14'),
(5,'2015-10-14','2015-10-15'),
(6,'2015-10-28','2015-10-29'),
(7,'2015-10-30','2015-10-31')

--QUERY EXECUTION 
-- 1: Assign group ID based on continuity
WITH ProjectGroups AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY Start_Date) 
        - DATEDIFF(DAY, '2015-10-01', Start_Date) AS Group_ID
    FROM Projects
)

--2: Group by that ID and get min/max
SELECT 
    MIN(Start_Date) AS Project_Start,
    MAX(End_Date) AS Project_End
FROM ProjectGroups
GROUP BY Group_ID
ORDER BY 
    DATEDIFF(DAY, MIN(Start_Date), MAX(End_Date)), 
    MIN(Start_Date);
