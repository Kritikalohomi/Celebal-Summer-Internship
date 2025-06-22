--Creation of TABLE Symmetric_Pair
CREATE TABLE Symmetric_Pair(
X int ,
Y int);

--Insertion of data in the TABLE Symmetric_Pair
INSERT INTO Symmetric_Pair
VALUES (20,20),
(20,20),
(20,20),
(20,21),
(23,22),
(22,23),
(21,20);

--Displaying the TABLE Symmetric_Pair
SELECT * FROM Symmetric_Pair

--Applying the query to find Symmetric Pairs 
SELECT DISTINCT a.X, a.Y
FROM Symmetric_Pair a
JOIN Symmetric_Pair b 
ON a.X=b.Y AND b.X=a.Y
WHERE a.X<=a.Y
ORDER BY a.X
