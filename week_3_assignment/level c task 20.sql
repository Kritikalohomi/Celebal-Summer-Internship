-- Table that contains the latest data
CREATE TABLE SourceTable (
  ID INT,
  Name VARCHAR(50),
  Department VARCHAR(50)
);

-- Table where we want to copy only new data
CREATE TABLE TargetTable (
  ID INT,
  Name VARCHAR(50),
  Department VARCHAR(50)
);

-- Inserting into SourceTable (this has all records, old + new)
INSERT INTO SourceTable (ID, Name, Department)
VALUES 
(1, 'Alice', 'HR'),
(2, 'Bob', 'Finance'),
(3, 'Charlie', 'IT'),
(4, 'David', 'Sales');  -- this is the NEW record

-- Inserting into TargetTable (only older data)
INSERT INTO TargetTable (ID, Name, Department)
VALUES 
(1, 'Alice', 'HR'),
(2, 'Bob', 'Finance'),
(3, 'Charlie', 'IT');

--QUERY EXECUTION 
INSERT INTO TargetTable (ID, Name, Department)
SELECT ID, Name, Department
FROM SourceTable

EXCEPT

SELECT ID, Name, Department
FROM TargetTable;

SELECT * FROM  SOURCETABLE
