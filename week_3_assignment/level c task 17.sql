--1: Create Login (Server level - master DB)
USE master;
GO

CREATE LOGIN Company_login 
WITH PASSWORD = 'Password@1234';
GO

--2: Switch to your database (replace 'TestDB' with your actual DB)
USE kritika11;
GO

-- 3: Create User in that DB
CREATE USER Company_user 
FOR LOGIN Company_login;
GO

-- 4: Grant db_owner role to the user
ALTER ROLE db_owner 
ADD MEMBER Company_user;
GO
