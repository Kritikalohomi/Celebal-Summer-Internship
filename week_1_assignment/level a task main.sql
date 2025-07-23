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
select distinct c.customerid,
isnull(p.firstname, '') + ' ' +
isnull(p.middlename, '') + ' ' +
isnull(p.lastname, '') as full_name,a.city
from sales.customer c
join person.person p on c.personid = p.businessentityid
join person.businessentityaddress bea on p.businessentityid = bea.businessentityid
join person.address a on bea.addressid = a.addressid
join sales.salesorderheader soh on c.customerid = soh.customerid
join sales.salesorderdetail sod on soh.salesorderid = sod.salesorderid
join production.product pr on sod.productid = pr.productid
where a.city = 'london'and pr.name = 'chai'
order by c.customerid;

--9 list of customer who never place an order
select distinct c.CustomerId, 
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name
from person.person p 
join sales.customer c
on c.personid =p.businessentityid
left join sales.salesorderheader soh 
on soh.customerid=c.customerid
where soh.customerid is null  

--10. list of customer who ordered tofu
select c.CustomerId, pp.name,
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name
from person.person p 
join sales.customer c
on c.personid =p.businessentityid
join [Sales].[SalesOrderHeader] soh
on c.customerid= soh.customerid
join [Sales].[SalesOrderDetail] sod
on soh.salesorderid=sod.salesorderid
join [Production].[Product] pp
on pp.productid=sod.productid 
where pp.name='tofu'

--11. Details of first order of the system
select top 1 c.CustomerId,soh.orderdate,
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name
from person.person p 
join sales.customer c
on c.personid =p.businessentityid
join [Sales].[SalesOrderHeader] soh 
on soh.customerid=c.customerid
order by soh.orderdate 

--12. Details of the most expensive order date  
select top 1 
soh.salesorderid,c.CustomerId,soh.orderdate,
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name,soh.totaldue
from person.person p 
join sales.customer c
on c.personid =p.businessentityid
join [Sales].[SalesOrderHeader] soh 
on soh.customerid=c.customerid
order by soh.totaldue desc

--13. for each order get the order id and average quantity of item in that order
select salesorderid, avg(orderqty) as avg_order_qty
from [Sales].[SalesOrderDetail]
group by salesorderid

--14. for each order get the orderid, minimum quantity , maximum quantity in that order
select salesorderid, min(orderqty) as minimun_quantity,
max(orderqty) as maximum_quantity
from [Sales].[SalesOrderDetail]
group by salesorderid
order by salesorderid

--15. get the list of managers and all the employees who report to them 
select manager.businessentityid as manager_id,
isnull(pmanager.firstname, '') + ' '+ 
isnull(pmanager.middlename, '')+' ' + 
isnull(pmanager.lastname,'') as manager_name,
emp.businessentityid as employee_id,
isnull(pemp.firstname, '') + ' '+ 
isnull(pmanager.middlename, '')+' ' + isnull(pemp.lastname, '') as employee_name
from 
humanresources.employee emp
join 
humanresources.employee manager 
on emp.organizationnode.GetAncestor(1) = manager.organizationnode
join 
person.person pmanager 
on manager.businessentityid = pmanager.businessentityid
join 
person.person pemp 
on emp.businessentityid = pemp.businessentityid
order by 
managername, employeename

--16. get the order id and total quantity for each order that has a total quantity of greater than 300
select salesorderid,sum(orderqty)as total_quantity
from [Sales].[SalesOrderDetail]
group by salesorderid
having sum(orderqty)>300
order by salesorderid

--17. List of all the orders placed on or after 1996/12/31
select sod.salesorderid , sod.productid, soh.orderdate
from [Sales].[SalesOrderDetail] sod
join [Sales].[SalesOrderHeader] soh
on sod.salesorderid=soh.salesorderid
where orderdate>='1996/12/31'
order by soh.orderdate 

--18.List of all the orders shipped to Canada 
select soh.salesorderid, soh.customerid, st.name
from [Sales].[SalesOrderHeader] soh
join [Sales].[SalesTerritory] st
on soh.territoryid = st.territoryid
where st.name='canada'

--19. List of all the orders with order total >200
select salesorderid as order_id, customerid , totaldue as order_total
from [Sales].[SalesOrderHeader] 
where totaldue>200
order by totaldue

--20. List of the countries and sales made in each country 
select st.name as country, sum(soh.totaldue) as Total_sales
from [Sales].[SalesOrderHeader] soh
join [Sales].[SalesTerritory] st 
on soh. territoryid=st.territoryid
group by st.name
order by total_sales desc

--21. list of customer contact name and number of order they have placed 
select isnull(p.firstname, '') + ' ' + 
isnull(p.middlename, '') + ' ' + 
isnull(p.lastname, '') as Full_name, c.customerid,
count(soh.salesorderid) as number_of_orders
from  sales.customer c
join  person.person p 
on c.personid = p.businessentityid
join sales.salesorderheader soh on c.customerid = soh.customerid
group by c.customerid, p.firstname, p.middlename, p.lastname
order by number_of_orders desc;

--22. list of customer contact names who have placed more than 3 orders 
select isnull(p.firstname, '') + ' ' + 
isnull(p.middlename, '') + ' ' + 
isnull(p.lastname, '') as Full_name, c.customerid,
count(soh.salesorderid) as number_of_orders
from  sales.customer c
join  person.person p 
on c.personid = p.businessentityid
join sales.salesorderheader soh on c.customerid = soh.customerid
group by c.customerid, p.firstname, p.middlename, p.lastname
having count(soh.salesorderid)>3
order by number_of_orders 

--23. list of discontinued product which were ordered between 1/1/1997 and 1/1/1998
select pp.productid, pp.name,soh.orderdate 
from production.product pp
join sales.salesorderdetail sod
on sod.productid=pp.productid
join sales.salesorderheader soh
on soh.salesorderid=sod.salesorderid
where discontinueddate is not null
and orderdate between '1997/01/01' and '1998/01/01'

--24. list of empolyee firstname and last name, supervisor firstname and lastname
select he.[BusinessEntityID], ep.firstname+' '+ep.lastname as employees_name
,sp.firstname+' '+sp.lastname as supervisor_name
from [HumanResources].[Employee] he
join [HumanResources].[Employee] hee 
on he.[OrganizationNode].GetAncestor(1)=hee.[OrganizationNode]
join person.person ep 
on ep.businessentityid=he.businessentityid
join person.person sp 
on sp.businessentityid=hee. businessentityid

--25. list of employees id and total sales conducted by them
select salespersonid as employees_id,
sum(totaldue) as total_sales 
from [Sales].[SalesOrderHeader]
group by salespersonid 

--26. name of the employee whose first name contain the character a 
select he.businessentityid as employee_id, 
isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name
from [HumanResources].[Employee] he
join person.person p
on he.businessentityid=p.businessentityid
where p.firstname like '%a%'
order by he.businessentityid

--27. list of the manager who have more than 4 people reporting to him
select mgr.businessentityid as managerid,
isnull(pm.firstname, '') + ' ' + isnull(pm.lastname, '') as managername,
count(*) as report_count
from humanresources.employee emp
join humanresources.employee mgr 
on emp.organizationnode.GetAncestor(1) = mgr.organizationnode
join person.person pm 
on mgr.businessentityid = pm.businessentityid
group by mgr.businessentityid, pm.firstname, pm.lastname
having count(*) > 4
order by report_count desc

--28. list of orders and product name 
select soh.salesorderid as order_id,
pp.productid, pp.name
from [Sales].[SalesOrderHeader] soh
join [Sales].[SalesOrderDetail] sod
on soh.[SalesOrderID]=sod.[SalesOrderID]
join production.product pp
on sod.productid=pp.productid
order by soh.salesorderid

--29. list of orders placed by the best customers 
select top 5 count(salesorderid), customerid
from [Sales].[SalesOrderHeader] 
group by customerid
order by count(salesorderid) desc

--30. list of orders placed by the customers who donot have fax number
--not able to find fax number in the database AdventureWorks2022

--31. list of postal codes where tofu was shipped 
select a.postalcode, pp.productid, pp.name, soh.customerid
from [Sales].[SalesOrderHeader] soh
join [Sales].[SalesOrderDetail] sod
on soh.[SalesOrderID]=sod.[SalesOrderID]
join [Production].[Product] pp
on pp.productid=sod.productid
join person.address a
on soh.[ShipToAddressID]=a.addressid
where pp.name='tofu'

--32. List of product names that were shipped to France
select distinct pp.productid,pp.name as product_name
from [Sales].[SalesOrderHeader] soh 
join [Sales].[SalesOrderDetail] sod
on soh.salesorderid=sod.salesorderid
join production.product pp
on sod.productid=pp.productid
join person.address a
on a.addressid=soh.[ShipToAddressID]
join person.StateProvince sp
on sp.[StateProvinceID]=a.stateprovinceid
where sp.CountryRegionCode='FR'

--33.list of product name and categories for the suppliers'Speciality biscuits' Ltd
select pp.name as product_name,pc.name as category_name
from production.product pp
join production.productsubcategory psc 
on pp.productsubcategoryid = psc.productsubcategoryid
join production.productcategory pc 
on psc.productcategoryid = pc.productcategoryid
join purchasing.productvendor pv 
on pp.productid = pv.productid
join purchasing.vendor v 
on pv.businessentityid = v.businessentityid
where v.name = 'speciality biscuits ltd';

--34. List of products that were never orderd
select pp.productid, pp.name as product_name
from  production.product pp
left join [Sales].[SalesOrderDetail] sod
on pp.productid=sod.productid
where sod.productid is null

--35. list of product where units in stock are less than 10 and units on order are 0
select p.productid, p.name as product_name,
pi.quantity as unitsinstock
from production.product p
join production.productinventory pi
on p.productid = pi.productid
left join sales.salesorderdetail sod
on p.productid = sod.productid
where pi.quantity < 10 and sod.productid is null;

--36. list of top 10 countries by sale 
select top 10 
cr.name, sum(sod.totaldue) as total_sales 
from [Sales].[SalesOrderHeader] sod 
join person.address a
on a.addressid=sod.billtoaddressid
join person.StateProvince sp
on sp.[StateProvinceID]=a.stateprovinceid
join [Person].[CountryRegion] cr
on sp.[CountryRegionCode]=cr.[CountryRegionCode]
group by cr.name
order by sum(sod.totaldue)

--37. no of orders each employee have taken for customers with customer id between A and AO solve this question using adventureworks2022 database 
select e.businessentityid as employeeid, p.firstname, p.lastname,
count(soh.salesorderid) as number_of_orders
from sales.salesorderheader soh
join sales.customer c 
on soh.customerid = c.customerid
join [humanresources].[employee] e 
on soh.salespersonid = e.businessentityid
join person.person p 
on e.businessentityid = p.businessentityid
where c.customerid >= 'a' and c.customerid <= 'ao'
group by e.businessentityid, p.firstname,  p.lastname
order by number_of_orders desc;

--38. order date of most expensive order
select top 1
salesorderid as orderid, orderdate, totaldue as amount
from [Sales].[SalesOrderHeader]
order by totaldue desc

--39. product name and total revenue from that product
select  pp.name, sum(sod.orderqty*sod.unitprice) as total_price
from [Sales].[SalesOrderDetail] sod
join Production.product pp
on sod.productid=pp.productid
group by pp.name
order by pp.name

--40. Supplierid and no. of products offered
select businessentityid as supplierid,
count(distinct productid) as numberofproducts
from purchasing.productvendor 
group by businessentityid
order by numberofproducts desc;

--41. Top 10 Customer based on their business
select top 10 
c.customerid , isnull(p.FirstName,'')+' '+
isnull(p.MiddleName,'')+' '+
isnull(p.LastName,'') as Full_Name, sum(totaldue) as total 
from [Sales].[SalesOrderHeader] soh
join sales.customer c 
on c.customerid= soh.customerid
join person.person p
on c.personid=p.businessentityid
group by c.customerid , p.firstname, p.middlename, p.lastname
order by SUM(totaldue) desc

--42. Total revenue of the company 
select sum(totaldue) as total_revenue 
from [Sales].[SalesOrderHeader]












