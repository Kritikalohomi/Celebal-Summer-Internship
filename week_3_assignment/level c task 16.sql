--CREATION OF THE TABLE SWAP_COLUMNS 
CREATE TABLE Swap_Columns 
(
ID int ,
Column1 int,
Column2 int
);

--INSERTING DATA INTO TABLE SAWP_COLUMNS 
INSERT INTO Swap_Columns
VALUES (1,100,200),
(2,300,500),
(3,300, 400)

--DISPLAYING THE TABLE 
SELECT * FROM Swap_Columns;

-- Swapping Column1 and Column2 in the Swap_Columns table
UPDATE Swap_Columns
SET 
  Column1 = swap.Column1,
  Column2 = swap.Column2
FROM (
  SELECT 
    ID,
    Column2 AS Column1,
    Column1 AS Column2
  FROM Swap_Columns
) AS swap
WHERE Swap_Columns.ID = swap.ID;


--SWAPPED COLUMN DISPLAY
select * from Swap_Columns

