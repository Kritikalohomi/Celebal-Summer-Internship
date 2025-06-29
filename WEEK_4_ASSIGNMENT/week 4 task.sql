--CREATION OF THE TABLE STUDENTDETAILS 
CREATE TABLE Studentdetails (
	StudentID int primary key,
	StudentName Varchar(100), 
	GPA real,
	Branch varchar(10),
	Section char);

--CREATION OF THE TABLE SUBJECTDETAILS
CREATE TABLE SubjectDetails(
	SubjectID Varchar(20) primary key,
	SubjectName Varchar(100),
	MaxSeats int,
	RemainingSeats int);

--INSERTING DATA INTO THE TABLE STUDENTDETAILS 
INSERT INTO StudentDetails
values(159103036, 'Mohit Agrawal',8.9,'CCE','A'),
(159103037, 'Rohit Agrawal',5.2,'CCE','A'),
(159103038, 'Shohit Garg',7.1,'CCE','B'),
(159103039, 'Mrinal Malhotra',7.9,'CCE','A'),
(159103040, 'Mehreet Singh ',5.6,'CCE','A'),
(159103041, 'Arjun Tehlan',9.2,'CCE','B');


--INSERTING DATA INTO THE TABLE SUBJECTDETAILS 
INSERT INTO SubjectDetails
VALUES('PO1491','Basics of Political Science',60, 2),
('PO1492','Basics of Accounting',120, 119),
('PO1493','Basics of Financial Market',90, 90),
('PO1494','Eco Philosophy',60, 50),
('PO1495','Automotive Trends',60, 60);

--DISPLAYING THE TABLES 
SELECT * FROM StudentDetails 
SELECT * FROM SubjectDetails

--CREATION OF THE TABLE STUDENTPREFERENCE
CREATE TABLE StudentPreference(
StudentID int FOREIGN KEY REFERENCES StudentDetails(StudentID),
SubjectID Varchar(20) FOREIGN KEY REFERENCES SubjectDetails(SubjectID),
Preference int);

--INSERTING DATA INTO THE TABLE STUDENTPREFERENCE
INSERT INTO StudentPreference
VALUES(159103036,'PO1491',1),
(159103036,'PO1492',2),
(159103036,'PO1493',3),
(159103036,'PO1494',4),
(159103036,'PO1495',5);

--CREATION OF THE TABLE ALLOTMENTS
CREATE TABLE Allotments(
SubjectID VARCHAR(20), 
StudentID INT
);

--CREATION OF THE TABLE UNALLOTEDSTUDENT
CREATE TABLE UnallotedStudents (
    StudentId INT
);

--DISPLAYING THE TABLE STUDENTPREFERENCE
SELECT * FROM StudentPreference

--QUERY EXECUTION 
DROP PROCEDURE IF EXISTS AllotSubject;
GO
CREATE PROC AllotSubject
AS 
BEGIN
	--deletion of old data
	DELETE FROM Allotments
	DELETE FROM UnallotedStudents
	
	--creation of cursor
	DECLARE Student_Cursor CURSOR FOR
	SELECT StudentID from 
	StudentDetails
	ORDER BY GPA DESC

	--variable declaration 
	DECLARE @StudentID INT;
	DECLARE @Preference INT =1;
	DECLARE @SubjectID VARCHAR(20);
	DECLARE @allotment BIT;

	--open cursor
	OPEN Student_cursor
	FETCH NEXT FROM Student_cursor into @StudentID
	
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @Preference=1;
		SET @Allotment=0;

		WHILE @Preference<=5 or @Allotment=1
		BEGIN
			SELECT @SubjectID=SubjectID FROM 
			StudentPreference
			WHERE StudentID=@StudentID and Preference=@Preference

			IF EXISTS(
			SELECT 1
			FROM SubjectDetails
			WHERE SubjectID=@SubjectID and RemainingSeats >0
			)
			BEGIN 

				--Insert the data into table allotments
				INSERT INTO Allotments(SubjectID,StudentID)
				values (@SubjectID,@StudentID);

				--decrease the reamaing seat
				UPDATE SubjectDetails
				SET RemainingSeats=RemainingSeats-1
				WHERE SubjectID=@SubjectID

				SET @Allotment=1
			END
			SET @Preference=@Preference+1
			END
			--if not alloted
			if @allotment=0
			BEGIN
			INSERT INTO UnallotedStudents(StudentID)
			Values(@StudentID)
			END
			FETCH NEXT FROM Student_cursor INTO @StudentID;
		END
		CLOSE Student_Cursor;
		DEALLOCATE Student_cursor;

END
--Executing the STORED PROCEDURE
exec allotsubject

--displaying the table allotment
select * from allotments

--displaying the table unallotedstudent
select * from unallotedStudents;

