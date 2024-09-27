use AddressBookService


--Strored procedure to create a Table
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
			Id INT IDENTITY(1,1) PRIMARY KEY,
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

--Stored Procedure to Insert Data into the Table
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

--Stored Procedure to Update the Table
DRop PROCEDURE SpUpdateContactDetails;

CREATE PROCEDURE SpUpdateContactDetails
    @TableName NVARCHAR(128),
	@AddressBookName VARCHAR(50),
    @NewFirstName VARCHAR(50),
    @NewLastName VARCHAR(50),
    @Address VARCHAR(100),
    @City VARCHAR(50),
    @State VARCHAR(50),
    @Zip VARCHAR(20),
    @PhoneNumber VARCHAR(20),
    @Email VARCHAR(50),
    @OldFirstName VARCHAR(50),
    @OldLastName VARCHAR(50)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    -- Build the SQL query dynamically to update the specific table
    SET @SQL = N'
    UPDATE [' + @TableName + '] 
    SET AddressBookName = @AddressBookName, FirstName = @NewFirstName, LastName = @NewLastName, 
        Address = @Address, City = @City, State = @State, 
        Zip = @Zip, PhoneNumber = @PhoneNumber, Email = @Email
    WHERE FirstName = @OldFirstName AND LastName = @OldLastName;';

    -- Execute the dynamic update query
    EXEC sp_executesql @SQL,
        N'@AddressBookName VARCHAR(50), @NewFirstName VARCHAR(50), @NewLastName VARCHAR(50), @Address VARCHAR(100), 
          @City VARCHAR(50), @State VARCHAR(50), @Zip VARCHAR(20), 
          @PhoneNumber VARCHAR(20), @Email VARCHAR(50), @OldFirstName VARCHAR(50), @OldLastName VARCHAR(50)',
        @AddressBookName, @NewFirstName, @NewLastName, @Address, @City, @State, @Zip, @PhoneNumber, @Email, @OldFirstName, @OldLastName;
END;



--For storing all the operations log
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