use AdventureWorks2022
go
--1. list of all the customer
select c.CustomerId, 
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name
from person.person p 
join sales.customer c
on c.customerid =p.businessentityid
order by c.customerid


--2. List of all the customer where company name ends in n
select c.customerid, s.name
from  sales.customer c 
join sales.store s 
on c.customerid=s.businessentityid
where s.name like'%n'
order by c.customerid

--3. list of all the customer who live in Berlin or London 
select c.customerid, pa.addressid,
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name, pa.City
from person.person p
join sales.customer c 
on c.customerid = p.businessentityid
join person.businessentityaddress b
on p.businessentityid = b.businessentityid
join person.address pa 
on pa.addressid=b.addressid
where pa.city ='berlin' or city='london'
order by c.customerid


--4.list of all the customer who live in UK or USA 
select c.customerid, pa.addressid,
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name, pa.City
from person.person p
join sales.customer c 
on c.customerid = p.businessentityid
join person.businessentityaddress b
on p.businessentityid = b.businessentityid
join person.address pa 
on pa.addressid=b.addressid
where pa.city ='uk' or city='usa'
order by c.customerid

--5. List of all the product sorted by product name 
select Productid, Name 
from [Production].[Product] 
order by name

--6. list of the product where product name start with A
select productid, name 
from [Production].[Product] 
where name like 'A%'

--7. List of customer who ever placed an order
select distinct c.customerid,
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name
from [Sales].[Customer] c 
join [Sales].[SalesOrderHeader] s 
on c.customerid=s.customerid
join person.person p
on c.personid= p.businessentityid
order by c.customerid

--8.List of customers who live in london and have brought chai 
select * from [Production].[Product]


