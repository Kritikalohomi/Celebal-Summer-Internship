--Creation of TABLE Contests
CREATE TABLE Contests(
Contest_ID int ,
Hacker_ID int,
Name Varchar(50));

--Creation of TABLE Colleges
CREATE TABLE Colleges(
College_ID int,
Contest_ID int
);

--Creation of TABLE Challenges
CREATE TABLE Challenges(
Challenge_ID int,
College_ID int
);

--Creation of TABLE View_Stats
CREATE TABLE View_Stats(
Challenge_ID int,
Total_Views int,
Total_unique_views int
);


--Creation of TABLE Submission_Stats
CREATE TABLE Submission_Stats(
Challenge_ID int,
Total_Submissions int,
Total_Accepted_Submissions int
);

--Insertion in the TABLE Contests
INSERT INTO Contests
VALUES (66406, 17973,'Rose'),
(66556, 79153,'Angela'),
(94828, 80275,'Frank')


--Insertion in the TABLE Colleges
INSERT INTO Colleges
VALUES (11219, 66406),
(32473, 66556),
(56685, 94828)

--Insertion in the TABLE Challenges 
INSERT INTO Challenges
VALUES (18765, 11219),
(47127, 11219),
(60292, 32473),
(72974, 56685)


--Insertion in the TABLE View_Stats
INSERT INTO View_Stats
VALUES (47127, 26,19),
(47127, 15,14),
(18765, 43, 10),
(18765, 72, 13),
(75516, 35, 17),
(60292, 11, 10),
(72974, 42, 15),
(75516, 75, 11)

--
--Insertion in the TABLE View_Stats
INSERT INTO Submission_Stats
VALUES (75516, 34,12),
(47127, 27,10),
(47127, 56, 18),
(75516, 74, 12),
(75516, 83, 8),
(72974, 68, 24),
(72974, 82, 14),
(47127, 28, 11)

--Display all the tables 
SELECT * FROM Contests
SELECT * FROM Colleges
SELECT * FROM Challenges
SELECT * FROM View_Stats
SELECT * FROM Submission_Stats

--Applying Query for the task
SELECT 
    cnt.Contest_ID, 
    cnt.Hacker_ID, 
    cnt.Name, 
    SUM(ISNULL(ss.Total_Submissions, 0)) AS Total_Submissions, 
    SUM(ISNULL(ss.Total_Accepted_Submissions, 0)) AS Total_Accepted_Submissions, 
    SUM(ISNULL(vs.Total_Views, 0)) AS Total_Views, 
    SUM(ISNULL(vs.Total_Unique_Views, 0)) AS Total_Unique_Views
FROM Contests cnt
LEFT JOIN Colleges clg
    ON cnt.Contest_ID = clg.Contest_ID
LEFT JOIN Challenges chlg
    ON clg.College_ID = chlg.College_ID
LEFT JOIN View_Stats vs
    ON chlg.Challenge_ID = vs.Challenge_ID
LEFT JOIN Submission_Stats ss 
    ON chlg.Challenge_ID = ss.Challenge_ID
GROUP BY cnt.Contest_ID, cnt.Hacker_ID, cnt.Name
HAVING 
    SUM(ISNULL(ss.Total_Submissions, 0)) > 0 OR 
    SUM(ISNULL(ss.Total_Accepted_Submissions, 0)) > 0 OR 
    SUM(ISNULL(vs.Total_Views, 0)) > 0 OR 
    SUM(ISNULL(vs.Total_Unique_Views, 0)) > 0
ORDER BY cnt.Contest_ID;


