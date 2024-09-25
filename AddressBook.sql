use AddressBookService

CREATE PROCEDURE CreateAddressBookTable
    @BookName NVARCHAR(128) -- Table name parameter
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    -- Build dynamic SQL query
    SET @SQL = N'
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = @TableName)
    BEGIN
        EXEC(''
        CREATE TABLE [' + @BookName + '] (
            AddressBookName VARCHAR(50),
            FirstName VARCHAR(50),
            LastName VARCHAR(50),
            Address VARCHAR(100),
            City VARCHAR(50),
            State VARCHAR(50),
            Zip VARCHAR(20),
            PhoneNumber VARCHAR(20),
            Email VARCHAR(50)
        )
        '');
    END';

    -- Execute dynamic SQL
    EXEC sp_executesql @SQL, N'@TableName NVARCHAR(128)', @TableName = @BookName;
END;

--InsertIntoAddressBook
Create PROCEDURE SpAddContactDetails
    @TableName NVARCHAR(128),
    @AddressBookName VARCHAR(50),
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Address VARCHAR(100),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Zip VARCHAR(20),
    @PhoneNumber VARCHAR(20),
    @Email VARCHAR(50)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    -- Execute the dynamic trigger creation query
    EXEC sp_executesql @SQL;

    -- Build the SQL query dynamically to insert into the specific table
    SET @SQL = N'
    INSERT INTO [' + @TableName + '] (AddressBookName, FirstName, LastName, Address, City, State, Zip, PhoneNumber, Email)
    VALUES (@AddressBookName, @FirstName, @LastName, @Address, @City, @State, @Zip, @PhoneNumber, @Email);';

    -- Execute the dynamic insert query
    EXEC sp_executesql @SQL,
        N'@AddressBookName VARCHAR(50), @FirstName VARCHAR(50), @LastName VARCHAR(50), @Address VARCHAR(100), @City VARCHAR(50), @State VARCHAR(50), @Zip VARCHAR(20), @PhoneNumber VARCHAR(20), @Email VARCHAR(50)',
        @AddressBookName, @FirstName, @LastName, @Address, @City, @State, @Zip, @PhoneNumber, @Email;

END;


--For storing all the operations
	CREATE TABLE dbo.AuditLog (
		LogID INT IDENTITY(1,1) PRIMARY KEY,
		TableName NVARCHAR(128),
		AddressBookName VARCHAR(50),
		FirstName VARCHAR(50),
		LastName VARCHAR(50),
		Address VARCHAR(100),
		City VARCHAR(50),
		State VARCHAR(50),
		Zip VARCHAR(20),
		PhoneNumber VARCHAR(20),
		Email VARCHAR(50),
		ActionTimestamp DATETIME DEFAULT GETDATE(),
		ActionType NVARCHAR(10)
	);














----ignore below
EXEC sp_rename 'AuditLog.InsertedAt', 'ActionTimestamp', 'COLUMN';

ALTER TABLE AuditLog
ADD ActionType NVARCHAR(10);

Select * from AuditLog

Drop table AuditLog

Select * from AddressBooks
 DRop table AddresBooks

 Drop table Example

 SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

Delete from AddressBooks
where FirstName = 'shiv';



SELECT * FROM sys.triggers WHERE name = 'trg_InsertLog_' + AddressBooks;


SELECT * FROM sys.triggers WHERE name = 'tr_InsertIntoAddressBook';
SELECT * FROM sys.triggers WHERE name = 'tr_UpdateAddressBook';
SELECT * FROM sys.triggers WHERE name = 'tr_DeleteAddressBookData';
drop trigger tr_AddressBook