CREATE DATABASE EMPLOYEEDETAILS
--EMPLOYEE TABLE
use EMPLOYEEDETAILS

--Creating a table
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

Select * From employee

--add column to table
Alter table employee
add behaviour varchar(10)

--remove column from table
Alter table employee
Drop COLUMN behaviour

--altering  table data
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY (super_id)
REFERENCES employee (emp_id)
ON DELETE NO ACTION;




--inserting data to the table
INSERT INTO employee VAlUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL,NULL);
--AFTER running this INSERT INTO branch VAlUES(1, 'Corporate', 100 , '2006-02-09');
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VAlUES(101, 'Jan', 'Levison', '1961-05-11', 'F', 110000, 100,1);

INSERT INTO employee VAlUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 102,NULL);
--AFTER running this INSERT INTO branch VAlUES(1, 'Corporate', 100 , '2006-02-09');
UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VAlUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102,2);
INSERT INTO employee VAlUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102,2);
INSERT INTO employee VAlUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102,2);

INSERT INTO employee VAlUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100,NULL);
--AFTER running this INSERT INTO branch VAlUES(3, 'Stamford', 106 , '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VAlUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106,3);
INSERT INTO employee VAlUES(108, 'Jim', 'Helpert', '1978-10-01', 'M', 71000, 106,3);

SELECT * FROM employee




--BRANCH TABLE
CREATE TABLE branch (
branch_id INT PRIMARY KEY,
branch_name VARCHAR(40),
mgr_id INT,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL,
);

INSERT INTO branch VAlUES(1, 'Corporate', 100 , '2006-02-09');
INSERT INTO branch VAlUES(2, 'Scranton', 102 , '1992-04-06');
INSERT INTO branch VAlUES(3, 'Stamford', 106 , '1998-02-13');

SELECT * FROM branch

--CLIENT TABLE
CREATE TABLE client(
client_id INT PRIMARY KEY,
client_name VARCHAR(40),
branch_id INT,
FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL,
);

INSERT INTO client VAlUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VAlUES(401, 'Lakawa Country', 2);
INSERT INTO client VAlUES(402, 'FedEx', 3);
INSERT INTO client VAlUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VAlUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VAlUES(405, 'Times Newspaper', 3);
INSERT INTO client VAlUES(406, 'FedEx', 2);
SELECT * FROM client

--WORKS WITH
CREATE TABLE works_with(
emp_id INT ,
client_id INT ,
total_sales INT,
PRIMARY KEY(emp_id, client_id),
FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE,
);
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);
SELECT * FROM works_with;

--branch supplier
CREATE TABLE branch_supplier(
branch_id INT,
supplier_name VARCHAR(40),
supply_type VARCHAR(40),
PRIMARY KEY(branch_id, supplier_name),
FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE,
);
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

SELECT * FROM branch_supplier;




--Operations 
SELECT * FROM employee
ORDER BY salary DESC;

SELECT * FROM employee
ORDER BY sex,first_name,last_name;

SELECT TOP(5)* FROM employee 
WHERE salary >63000;

--SELECT COUNT(emp_id) AS FEMALE
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day> '1971-01-01';

SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

SELECT SUM(salary)
FROM employee

SELECT count(sex),sex as gender
FROM employee
GROUP BY sex;

SELECT emp_id, sum(total_sales)
FROM works_with
GROUP BY emp_id


--wildcard % = any  and _ = one character
SELECT * FROM client
WHERE client_name LIKE 'L%' --starts with L

SELECT * FROM client
WHERE client_name LIKE '%LLC' --end with

SELECT * FROM client
WHERE client_name LIKE '%Daly%' --consist between

SELECT * FROM client
WHERE client_name LIKE '__hn%' 


--UNION
--error if SELECT first_name,last_name
SELECT first_name
FROM employee
UNION
SELECT branch_name
FRom branch;


--Joins
SELECT employee.emp_id,employee.first_name, branch.branch_name
FROM employee
FULL Join branch
ON  branch.mgr_id =employee.emp_id 
--left join gives all the data from left table
--right join gives all the data from the right table
--join/inner join give common data from all table
--full join gives all the table data of both for selected columns
INSERT into branch values(4,'Nuffalo',NULL,NULL)


--Nested Queries
SELECT employee.first_name,employee.last_name
FROM employee
WHERE employee.emp_id IN(
	SELECT works_with.emp_id
	FROM works_with
	WHERE works_with.total_sales>30000
	);

SELECT client.client_name
FROM client
WHERE client.branch_id=(
	SELECT branch.branch_id
	FROM branch
	WHERE branch.mgr_id =102);


--Cascade is used when someones foreign key is primary key of other table and primary data cannot be null

Create table TbEmployee(
Id Int Primary Key,
Name varchar(20),
ManagerId Int,
)

SElect * from TbEmployee

Insert into TbEmployee(Id,Name,ManagerId)
Values
(1,'Neha',Null),
(2,'Jenna',3),
(3,'Rohit',2),
(4,'Tom',3)

select E.Name as EmployeeName,M.Name as ManagerName
from TbEmployee as E
Left join TbEmployee as M
on M.Id = E.ManagerId
Order by M.Name



Select * from employee
Select Max(salary) As secondmax
from employee
where salary <(Select Max(salary)from employee);

Select distinct salary,first_name from employee
Order by salary desc
OFFSET 1 ROWS FETCH NEXT 4 ROW only;
--or
OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY;



Select * from employee

Select Max(salary) As Thirdmax
from employee
where salary <(Select Max(salary) As secondmax  from employee where salary < (Select Max(salary)from employee))






--Cluster in Sql---
CREATE TABLE Books
(
    BookID INT PRIMARY KEY CLUSTERED, -- Clustered index on BookID
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50)
);

INSERT INTO Books (BookID, Title, Author, Genre)
VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction'),
(2, '1984', 'George Orwell', 'Dystopian'),
(3, 'Pride and Prejudice', 'Jane Austen', 'Romance'),
(4, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction'),
(5, 'Moby-Dick', 'Herman Melville', 'Adventure');


-- Create a non-clustered index on Author
CREATE NONCLUSTERED INDEX IX_Author
ON Books (Author);

-- Create a non-clustered index on Genre
CREATE NONCLUSTERED INDEX IX_Genre
ON Books (Genre);

-- Query using the clustered index on Author
Select * from Books 
where BookId = 3

-- Query using the non-clustered index on Author
SELECT * FROM Books
WHERE Author = 'Harper Lee';

-- Query using the non-clustered index on Genre
SELECT * FROM Books
WHERE Genre = 'Fiction';


CREATE TABLE Employees (
    EmployeeID int Primary key,
	FirstName NVARCHAR(20),
	LastName NVARCHAR(20),
	Age INT,
	DepartmentID Int
);

Drop Table Employees
Select * from Employees;
ALTER TABLE Employees
ADD
    Age INT;
INSERT INTO Employees (EmployeeID, FirstName, LastName, Age, DepartmentID) 
VALUES (1,	'John',	'Doe',	28,	1),(2,'Jane',	'Smith',	34,	1),(3,	'Bob',	'Brown',	45,	2),(4,	'Alice',	'Johnson',	38,	1),(5,	'Mike',	'Davis',	22,	2);

SELECT DepartmentID, COUNT(*) AS NumEmployees 
FROM Employees 
GROUP BY DepartmentID 
HAVING COUNT(*) > 2;
