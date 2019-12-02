--create table Employees(
-- EmpId number,
-- FirstName VARCHAR2(20),
-- LastName VARCHAR2(20),
-- EmailId VARCHAR2(50),
-- Gender CHAR(1),
-- MobileNo CHAR(10),
-- DateOfJoining DATE DEFAULT sysdate,
-- DeptId int,
-- Salary number(10,2)
--);

--alter table Employees add DOB date;

--alter table Employees add(Salary number(10,2), col1 number);

--alter table Employees modify col1 varchar2(10);

--alter table Employees drop column  Salary;

--Set as unused means mark for delete but witouht releasing from memory
--alter table Employees set UNUSED column  col1;

--At a time of lower traffic the column could be deleted safely
--alter table Employees drop UNUSED COLUMNS;

--Drop a table
--drop TABLE Employees;

--Truncate
--truncate TABLE Employees;

--desc Employees;

--desc ALL_CONSTRAINTS Employees;

--create table Departments(
-- DeptId number,
-- Name VARCHAR2(20)
--);

-- Describe a table
--desc departments;

--alter table employees
--add CONSTRAINT Emp_Dept_Rel FOREIGN KEY(DeptID)
--REFERENCES Departments(DeptId) on DELETE set null;

-- list all constraints from table EMPLOYEES
--SELECT * FROM SYS.USER_CONSTRAINTS WHERE TABLE_NAME='EMPLOYEES';

-- EmpId number,
-- FirstName VARCHAR2(20),
-- LastName VARCHAR2(20),
-- EmailId VARCHAR2(50),
-- Gender CHAR(1),
-- MobileNo CHAR(10),
-- DateOfJoining DATE DEFAULT sysdate,
-- DeptId int

--Create a new department
--insert into Departments values(1, 'DevOps');
--insert into Departments values(2, 'AppSupport');

--Create a new Employee, asign new user to devops department
--insert into Employees values(101, 'Eduardo' , 'Fernandez', 'fernandez9000@gmail.com', 'M', '4698314596', sysdate, 1, sysdate);
--insert into Employees values(102, 'Andy' , 'Garcia', 'andy.garcia@gmail.com', 'M', '4698314599', sysdate, 2, sysdate);

-- update a record
--update Employees set DeptID=2 where EmpID=101;

--delete a record
--delete Employees where EmpID = 102;

-- use of merge, used to updated records into the copy table if deffer from origin
--create table copy_emp(
-- EmpId number,
-- FirstName VARCHAR2(20),
-- LastName VARCHAR2(20),
-- MobileNo CHAR(10),
-- DeptId int
--);

--update Employees set deptid=1 where empid=101;

--merge into copy_emp c
--using Employees e
--on (e.empid = c.empid)
--when matched then
--update set
--c.firstname = e.firstname,
--c.lastname = e.lastname,
--c.mobileno = e.mobileno,
--c.deptid = e.deptid
--when not matched then
--insert values(e.empid, e.firstname, e.lastname, e.mobileno, e.deptid);

-- create a savepoint so db can be rolled back to it
--savepoint modifications;

--manage transactions
-- insert, update, ... a record

-- The previous modifications would not be commited
--rollback into modifications;

--rollback and commit can also be used after statements
--alter table Employees add (Salary number(10,2));
--commit; or rollback;

--Select and aliases
--select Firstname ||' '|| lastname as "Employee name", Salary*12 as "Annual salary"  from Employees;

--Using Distinct
--select DeptID from EMPLOYEES;
--select DISTINCT DeptID from EMPLOYEES;

--Sorting
--select Firstname ||' '|| lastname as "Employee name", Salary*12 as "Annual salary"  from Employees;
--select Firstname ||' '|| lastname as "Employee name", Salary*12 as "Annual salary"  from Employees
--order by "Employee name";

--Group by
--select Firstname ||' '|| lastname as "Employee name", Salary*12 as "Annual salary", DEPTID as "Department", count(DEPTID)  from Employees
--group by DEPTID order by DEPTID;

--Filtering data
--use where and operators =, >, <, >=, ,<= and !=
--compound statements can also be donde using operators 'and' 'or' and 'not'
--Special operators IN('M','F'), BETWEEN ... AND , LIKE and IS NULL

--Functions
--char, number, date, conversion and general functions 
--select NEXT_DAY(TRUNC(SYSDATE), 'THURSDAY') from dual;
--select to_char(SYSDATE, 'ddsp mon yyyy HH : MI : SS AM') from dual;

-----Oracle Propietary Joins
--Equijoin or Inner join
select e.FirstName as "First name", e.LastName as "Last name", d.NAME as "Department name"
from Employees e, DEPARTMENTS d
where  e.DEPTID = d.DEPTID;

--Left join (All the employees, even those with no assigned department deptid = null)
select e.FirstName as "First name", e.LastName as "Last name", d.NAME as "Department name"
from Employees e, DEPARTMENTS d
where  e.DEPTID = d.DEPTID(+);

--Right join (All the departments, even those with no assigned employees deptid = null)
select e.FirstName as "First name", e.LastName as "Last name", d.NAME as "Department name"
from Employees e, DEPARTMENTS d
where  e.DEPTID(+) = d.DEPTID;

------ SQL Compliant joins
--Cross join (Cartesian product)
select FirstName as "First name", LastName as "Last name", Departments.NAME
from EMPLOYEES cross join Departments;

--Inner join (All the employees with assigned department deptid != null)
select FirstName as "First name", LastName as "Last name", Departments.NAME
from EMPLOYEES natural join Departments;

--Inner join (All the employees with assigned department deptid != null)
select FirstName as "First name", LastName as "Last name", Departments.NAME
from EMPLOYEES join Departments
using(DEPTID);

--full join (All the employees, departments and locations)
select FirstName as "First name", LastName as "Last name", EMPLOYEES.DEPTID, Departments.LOCATION_ID, Departments.NAME, Locations.City
from EMPLOYEES full join Departments
on EMPLOYEES.DEPTID = Departments.DEPTID
full join LOCATIONS
on Departments.LOCATION_ID = LOCATIONS.LOCATION_ID;

--Group functions
select sum(Salary), avg(Salary), MIN(SALARY), MAX(Salary) from Employees;

--Group by
select Firstname ||' '|| lastname as "Employee name", Salary*12 as "Annual salary", DEPTID as "Department", count(DEPTID)  from Employees
group by DEPTID, FIRSTNAME, LASTNAME, SALARY;

--Rollup
select Firstname ||' '|| lastname as "Employee name", Salary*12 as "Annual salary", count(DEPTID)  from Employees
group by ROLLUP(FIRSTNAME, LASTNAME, SALARY)
order by 1, 2;

--Subqueries
-- Query who makes more than minimum salary
-- Can be also used to update records
select * from(
  select Min(Salary) as "Min Salary" from Employees
), Employees where Employees.Salary > "Min Salary";

--Sequences

--Create synonyms
create synonym emp for Employees;
select * from emp;
drop SYNONYM emp;

--Create users
create user c##eduardo identified by students;

grant create session, create table, create view, create synonym to c##eduardo;

grant select on Employees to c##eduardo;

grant insert, update on Employees to c##eduardo;

--Managing roles
create role c##manager;
grant create session, create table, create view, create synonym to c##manager;
grant c##manager to c##eduardo;