use master;
--creation of the table SubjectAllotments
CREATE TABLE SubjectAllotments(
StudentID varchar(50),
SubjectID varchar(50),
Is_valid bit);

--insertion of data in the table SubjectAllotments
INSERT INTO SubjectAllotments
values('159103036','PO1491',1),
('159103036','PO1492',0),
('159103036','PO1493',0),
('159103036','PO1494',0),
('159103036','PO1495',0);

--display the table subjectAllotments
SELECT * FROM SubjectAllotments;

--creation of the table SubjectRequest
CREATE TABLE SubjectRequest(
StudentID VARCHAR(50),
SubjectID VARCHAR(50)
);

--insertion of datat into table SubjectRequest
insert into SubjectRequest
values('159103036','PO1496')

select * from SubjectRequest

--QUERY creation 
alter PROCEDURE proc_SubjectRequests
AS
BEGIN
	DECLARE @StudentID VARCHAR(50);
	DECLARE @NewSubjectID VARCHAR(50);
	DECLARE @CurrentSubjectID VARCHAR(50);

	DECLARE request_cursor CURSOR FOR
	SELECT StudentID, SubjectID
	from SubjectRequest

	OPEN request_cursor
		FETCH NEXT FROM request_cursor INTO @StudentID, @NewSubjectID;

		WHILE @@FETCH_STATUS=0
		BEGIN
			SELECT @CurrentSubjectID=SubjectID
			FROM SubjectAllotments
			WHERE @StudentID=StudentID AND Is_Valid=1

			--If no subjectc is alloted then 
			IF @CurrentSubjectID=null
			BEGIN
				INSERT INTO SubjectAllotments(StudentID, SubjectID, Is_valid)
				VALUES (@StudentID, @newSubjectID, 1)
			END
			ELSE
			BEGIN 
				IF @currentsubjectID<>@newSubjectID
				BEGIN
					UPDATE SubjectAllotments
					SET is_valid = 0 
					WHERE @StudentID=StudentID AND @CurrentSubjectID=SubjectID
					
					--insert new subject as current
					INSERT INTO SubjectAllotments(StudentID, SubjectID, Is_valid)
					VALUES(@StudentID,@NewSubjectID,1)
				END
			END
			FETCH NEXT FROM request_cursor INTO @studentID, @newSubjectID;
		END
		CLOSE request_cursor;
		DEALLOCATE request_cursor;
END

--query execution 
exec proc_SubjectRequests

--testing the data
select * from SubjectAllotments
--