
CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10),
    Age INT,
    Standard NVARCHAR(10)
);

INSERT INTO Students (ID, Name, Gender, Age, Standard)
VALUES 
(1, 'Alice Johnson', 'Female', 14, '8th'),
(2, 'Bob Smith', 'Male', 15, '9th'),
(3, 'Charlie Brown', 'Male', 13, '7th'),
(4, 'Diana Prince', 'Female', 14, '8th'),
(5, 'Ethan Hunt', 'Male', 16, '10th');

Select * from Students


--CTE is the temporary result set
--Exist only in memory while the query is running after that CTE is discared

--Select
WITH New_Cte
As
(
	select * from Students where Gender = 'Male'
)
SELECT * from New_Cte where Age >13;


--CTE with column Name 
WITH New_Cte(std_id, std_name, std_class)
As
(
	select ID, Name, [Standard] from Students
)
SELECT std_id, std_name from New_Cte;


--Insert
WITH New_Cte
As
(
	select * from Students
)
Insert New_Cte 
values(6, 'Neha Sharma', 'Female', 20, '12th'),
values(7, 'Ritvik Jaiswal', 'Male', 20, '12th');

--Update
WITH New_Cte
As
(
	select * from Students
)
Update New_Cte
set name = 'Darsh Sawant'
where ID = 2;

--Delete
WITH New_Cte
As
(
	select * from Students
)
Delete New_Cte
where ID = 2;


--View
--View is store as a physical object in the database and only store the query not the result/output
Create View vStudents
as
WITH New_Cte
As
(
	select * from Students where Gender = 'Male'
)
SELECT * from New_Cte 


Select *from vStudents;
Drop View vStudents


--More than one CTE
WITH New_Cte
As
(
	select * from Students where Age<15
),
New_Cte1
As
(
	select * from Students where Age>=15
)
SELECT * from New_Cte
UNION all
SELECT * from New_Cte1


--Over Clause with Partition/Windowing -2005
Select Name, Age, Gender, count(Gender) over (Partition by Gender) from Students

Alter Table Students
Add  Fees Decimal(10,2);

Update Students
Set Fees = Case
	When ID = 1 Then 20000
	When ID = 2 Then 25000
	When ID = 3 Then 30000
	When ID = 4 Then 25000
	When ID = 5 Then 20000
	When ID = 6 Then 20000
	When ID = 7 Then 30000
	else Fees
END
WHERE ID In(1, 2, 3, 4, 5, 6, 7);


Select Name, Age, Gender,Fees,  
count(Gender) over (Partition by Gender) as Grand_Total,
Max(Fees)over (Partition by Fees) as Max_Fees, 
Min(Fees) over (Partition by Fees) as Min_Fees, 
AVG(Fees) over (Partition by Fees) as AVG_Fees from Students