-- 1: Generate numbers from 2 to 1000
WITH NUMBERS AS (
	SELECT 2 AS NUM 
	UNION ALL 
	SELECT NUM + 1 
	FROM NUMBERS 
	WHERE NUM < 1000
),

--  2: Join each number with others to find divisors
DIVISOR AS (
	SELECT N.NUM AS OriginalNum, D.NUM AS Divisor
	FROM NUMBERS N 
	JOIN NUMBERS D 
	ON N.NUM % D.NUM = 0
),

-- 3: Find numbers with exactly 2 divisors = Prime
PRIMECHECK AS (
	SELECT OriginalNum AS Num
	FROM DIVISOR 
	GROUP BY OriginalNum
	HAVING COUNT(*) = 2
)

--  4: Join all primes with &
SELECT STRING_AGG(CAST(Num AS VARCHAR), '&') AS PrimesUpTo1000
FROM PRIMECHECK

OPTION (MAXRECURSION 1000);
