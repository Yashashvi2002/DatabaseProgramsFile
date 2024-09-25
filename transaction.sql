--transaction 
drop table Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Salary DECIMAL(18, 2)
);

CREATE TABLE SalaryChangeLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(18, 2),
    NewSalary DECIMAL(18, 2),
    ChangeDate DATETIME DEFAULT GETDATE()
);


INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (101, 'Alice Smith', 50000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (102, 'Bob Johnson', 60000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (103, 'Charlie Brown', 55000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (104, 'Diana Prince', 70000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (105, 'Evan White', 45000);


--trasaction logic
BEGIN TRY
    BEGIN TRANSACTION; 

    DECLARE @OldSalary DECIMAL(18, 2);
    DECLARE @NewSalary DECIMAL(18, 2) = 60000; -- New salary
    DECLARE @EmployeeID INT = 101; -- Employee ID to update

    -- Retrieve the old salary
    SELECT @OldSalary = Salary FROM Employees WHERE EmployeeID = @EmployeeID;

    -- Update the salary
    UPDATE Employees 
    SET Salary = @NewSalary 
    WHERE EmployeeID = @EmployeeID;

    
    INSERT INTO SalaryChangeLog (EmployeeID, OldSalary, NewSalary)
    VALUES (@EmployeeID, @OldSalary, @NewSalary);

    COMMIT TRANSACTION; 

    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    
    ROLLBACK TRANSACTION;

    
    PRINT 'Transaction rolled back due to an error.';
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;




SELECT *from SalaryChangeLog