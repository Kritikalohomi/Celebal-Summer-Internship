--Creation of the TABLE Hackers
CREATE TABLE Hackers(
Hacker_ID int ,
Name Varchar(40));

-- Creation of the TABLE Submissions
CREATE TABLE Submissions(
Submission_Date Date,
Submission_ID int,
Hacker_ID int,
Score int);

--Insertion in the TABLE Hackers
INSERT INTO Hackers 
VALUES(15758,'Rose'),
(20703,'Angela'),
(36396,'Frank'),
(38289,'Patrick'),
(44065,'Lisa'),
(53473,'Kimberly'),
(62529,'Bonnie'),
(79722,'Michael');

--Insertion in the TABLE Submissions
INSERT INTO Submissions 
VALUES ('2016-03-01',8494,20703,0),
('2016-03-01',22403,53473,0),
('2016-03-01',23965,79722,0),
('2016-03-01',30173,36396,0),
('2016-03-02',34928,20703,0),
('2016-03-02',38740,15758,0),
('2016-03-02',42769,79722,0),
('2016-03-02',44364,79722,0),
('2016-03-03',45440,20703,0),
('2016-03-03',49050,36396,0),
('2016-03-03',50273,79722,0),
('2016-03-04',50344,20703,0),
('2016-03-04',51360,44065,0),
('2016-03-04',54404,53473,0),
('2016-03-04',61533,79722,0),
('2016-03-05',72852,20703,0),
('2016-03-05',74546,30289,0),
('2016-03-05',76487,62529,0),
('2016-03-05',82439,36396,0),
('2016-03-05',90006,36396,0),
('2016-03-06',90404,20703,0)

--Displaying the TABLES
SELECT * FROM Hackers
SELECT * FROM Submissions

--Applying the query
SELECT SUBMISSION_DATE ,COUNT(DISTINCT HACKER_ID) AS UNIQUE_HACKERS
FROM SUBMISSIONS GROUP BY Submission_Date))

  SELECT SUBMISSION_DATE , HACKER_ID, COUNT(HACKER_ID) AS SUBMISSION_COUNT
  FROM SUBMISSIONS
  GROUP BY SUBMISSION_DATE, HACKER_ID
  ORDER BY SUBMISSION_DATE 

  SELECT SUBMISSION_DATE , HACKER_ID, COUNT(HACKER_ID) AS SUBMISSION_COUNT, 
  ROW_NUMBER()OVER(PARTITION BY SUBMISSION_DATE
  ORDER BY COUNT(*) DESC, HACKER_ID ) AS RN
  FROM SUBMISSIONS
  GROUP BY SUBMISSION_DATE, HACKER_ID
  ORDER BY SUBMISSION_DATE 
