CREATE PROCEDURE autodataflow
AS
BEGIN

    TRUNCATE TABLE DimCustomers;
    INSERT INTO DimCustomers (DimCustomerID, FirstName, LastName, CityName)
    SELECT ROW_NUMBER() OVER(ORDER BY c.CustomerID) AS DimCustomerID,
           c.FirstName, c.LastName, ci.CityName
    FROM BankDB.dbo.Customers c
    JOIN BankDB.dbo.Cities ci ON c.CityID = ci.CityID;

    TRUNCATE TABLE DimAccounts;
    INSERT INTO DimAccounts (DimAccountID, AccountNumber, Balance, OpenDate)
    SELECT ROW_NUMBER() OVER(ORDER BY a.AccountID) AS DimAccountID,
           a.AccountNumber, a.Balance, a.OpenDate
    FROM BankDB.dbo.Accounts a;

    TRUNCATE TABLE DimAccountTypes;
    INSERT INTO DimAccountTypes (DimAccountTypeID, TypeName)
    SELECT at.AccountTypeID, at.TypeName
    FROM BankDB.dbo.AccountTypes at;

    TRUNCATE TABLE FactTransactions;
    INSERT INTO FactTransactions (TransactionID, AccountID, TransactionType, Amount, TransactionDate, Description, DimCustomerID, DimAccountID, DimAccountTypeID)
    SELECT t.TransactionID, t.AccountID, t.TransactionType, t.Amount, t.TransactionDate, t.Description,
           c.CustomerID, a.AccountID, at.AccountTypeID
    FROM BankDB.dbo.Transactions t
    JOIN BankDB.dbo.Accounts a ON t.AccountID = a.AccountID
    JOIN BankDB.dbo.AccountTypes at ON a.AccountTypeID = at.AccountTypeID
    JOIN BankDB.dbo.Customers c ON a.CustomerID = c.CustomerID;

END;


