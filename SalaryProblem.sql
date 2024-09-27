CREATE TABLE EmployeeSalaries (
    EmployeeID INT,
    Salary DECIMAL(10, 2),
    Month VARCHAR(10)
);
-- Inserting salary data for different employees for January
INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5000, 'January'),
(102, 2000, 'January'),
(103, 3000, 'January');

-- Inserting salary data for February
INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 4500, 'February'),
(102, 2100, 'February'),
(103, 3100, 'February');

-- Inserting salary data for March
INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 4700, 'March'),
(102, 2200, 'March'),
(103, 3200, 'March');

-- Continue inserting for other months...
INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 4800, 'April'),
(102, 2300, 'April'),
(103, 3300, 'April');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 4900, 'May'),
(102, 2400, 'May'),
(103, 3400, 'May');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5100, 'June'),
(102, 2500, 'June'),
(103, 3500, 'June');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5200, 'July'),
(102, 2600, 'July'),
(103, 3600, 'July');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5300, 'August'),
(102, 2700, 'August'),
(103, 3700, 'August');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5400, 'September'),
(102, 2800, 'September'),
(103, 3800, 'September');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5500, 'October'),
(102, 2900, 'October'),
(103, 3900, 'October');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5600, 'November'),
(102, 3000, 'November'),
(103, 4000, 'November');

INSERT INTO EmployeeSalaries (EmployeeID, Salary, Month) VALUES
(101, 5700, 'December'),
(102, 3100, 'December'),
(103, 4100, 'December');


Select *from EmployeeSalaries

Select Sum(TotalSalary) as CombinedSalary
from
(
select sum(salary) as TotalSalary ,EmployeeID from EmployeeSalaries
group by EmployeeID
having sum(salary)>35000
) 
As TotalSalaryOfHighest



--transaction 

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


INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (101, 'Alice Smith', 50000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (102, 'Bob Johnson', 60000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (103, 'Charlie Brown', 55000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (104, 'Diana Prince', 70000);
INSERT INTO Employees (EmployeeID, Name, Salary) VALUES (105, 'Evan White', 45000);