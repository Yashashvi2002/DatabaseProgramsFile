use Triggers
Drop Table Employees
Drop Table EmployeeAudit
Drop Table department
Drop View vwEmployeeDeatails
DROP trigger tr_for_insert
DROP trigger tr_for_update
DROP trigger tr_viewEmployDetails_InsteadOfInsert


SELECT * FROM Employees
SELECT * FROM EmployeeAudit

DROP TABLE EmployeeAudit
DROP TABLE Employees
DROP trigger tr_for_insert


Create table Employees(
Id INT Primary key,
name VARCHAR(20),
salary INT,
gender VARCHAR(20),
deparmentId INT
);

Create table EmployeeAudit(
 Id INT IDENTITY(1,1) PRIMARY KEY,
AuditDAta VARCHAR(2000)
);


--This trigger was for insert
Create trigger tr_for_insert
on Employees
for INSERT
AS
BEGIN
	DECLARE @Id INT
	Select @Id = Id from inserted
	 
	INSERT into EmployeeAudit
	values('New employee with id = '+ Cast(@Id as varchar(5)) + 'is added at' +Cast(GETDATE() as varchar(20)))
END

Insert into Employees values (1,'John', 5000, 'Male', 3)
Insert into Employees values (2,'Mike', 3400, 'Male', 2)
Insert into Employees values (3,'Pam', 6000, 'Female', 1)
Insert into Employees values (4,'Jane',10000, 'Female', 2)


--This trigger was for delete
Create Trigger tr_for_delete
on Employees
for delete
as
begin
	DECLARE @Id INT
	Select @Id = Id from deleted
	 
	INSERT into EmployeeAudit
	values('New employee with id = '+ Cast(@Id as varchar(5)) + 'is deleted at ' + Cast(GETDATE() as varchar(20)))
end

Delete from Employees
where id = 4;


drop trigger tr_for_update







--This trigger was for update
Create trigger tr_for_update
on Employees
for UPDATE
AS
BEGIN
	Select * from deleted --contains old data
	Select * from inserted --contains new data
	DECLARE @Id INT
	Select @Id = Id from inserted
	 
	INSERT into EmployeeAudit
	values('Employee with id = '+ Cast(@Id as varchar(5)) + 'is updated at '  + Cast(GETDATE() as varchar(20)))
END




--trigger for update with different condtition
Alter trigger tr_for_update
on Employees
for UPDATE
AS
BEGIN
	Declare @id int
	Declare @Oldname varchar(30), @Newname varchar(30)
	Declare @Oldsalary int, @Newsalary int
	Declare @Oldgender varchar(20),@Newgender varchar(20)
	Declare @OldDeptId int, @NewDeptId int

	Declare @AuditString Nvarchar(1000)

	Select * 
	into #TempTable
	from inserted

	While(Exists(Select Id from #TempTable))
	Begin
		set @AuditString = ''

		Select Top 1 @Id = Id, @Newname = Name	, @Newsalary = Salary,  @Newgender = gender,@NewDeptId = deparmentId
		From #TempTable

		Select  @Id = Id, @Oldname = Name, @Oldsalary = Salary,@Oldgender = gender,	@OldDeptId = deparmentId
		From deleted where Id = @Id

		Set @AuditString = 'Employee with Id = ' + Cast(@Id as nvarchar(5)) + 'changed '
		 if(@Oldname<>@Newname)
			Set @AuditString =	@AuditString + 'Name from ' + @Oldname + ' to ' + @Newname 

		 if(@Oldsalary<>@Newsalary)
			Set @AuditString = @AuditString + ' Salary from ' + CAST(@Oldsalary as nvarchar(20))+ ' to ' + CAST(@Newsalary as nvarchar(20))

		 if(@Oldgender<>@Newgender)
			Set @AuditString =	@AuditString + ' Gender from ' + @Oldgender + ' to ' + @Newgender
		 
		 if(@OldDeptId<>@NewDeptId)
			Set @AuditString = @AuditString + ' DepartmentId from ' +CAST(@OldDeptId as nvarchar(20)) + ' to ' + CAST(@NewDeptId as nvarchar(20))

		insert into EmployeeAudit values (@AuditString)
		Delete from #TempTable where Id =@Id
	END
END

Update Employees set name = 'Jenny', salary = 8000, gender ='Female'
where id = 4;


--  View and Trigger together ----------------------
--updating the original tables using View and trigger

Create Table department(
deparmentId Int,
Deptname varchar(20),
)
Insert into department values(1,'IT')
Insert into department values(2,'PayRoll')
Insert into department values(3,'HR')
Insert into department values(4,'Admin')



--View creation
Create View vwEmployeeDeatails
as
Select Id, name,gender, Deptname
from Employees as e
join department as d
on d.deparmentId = e.deparmentId

Drop view vwEmployeeDeatails
--Instead of Insert
Select * from
vwEmployeeDeatails

Drop trigger tr_viewEmployDetails_InsteadOfInsert

Create Trigger tr_viewEmployDetails_InsteadOfInsert
on vwEmployeeDeatails
Instead of Insert
as
begin
	Declare @DeptId int

	Select @DeptId = deparmentId
	from department
	join inserted
	on inserted.DeptName = department.DeptName

	--Select * from inserted
	if(@DeptId is null)
	Begin
		Raiserror('Invalid Department Name. Statement terminated', 16,1)
		return
	end

	insert into Employees(Id, name, gender, deparmentId)
	Select Id, name,gender, @DeptId
	from inserted
end

Insert into vwEmployeeDeatails values(4,'Jenna', 'Female', 'PayRoll')
select * from Employees

Update Employees
set salary = 8000
where Id = 4;

Update Employees
set salary = 7500
where Id = 5;


--Instead of Update
Create Trigger tr_viewEmployDetails_InsteadOfUpdate
on vwEmployeeDeatails
Instead of Update
as
begin
	
	
end



SELECT DepartmentID, COUNT(*) FROM Employees GROUP BY DepartmentID;



















