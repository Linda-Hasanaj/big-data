CREATE database dwh_bankdb;
use dwh_bankdb;

-- Dimension: Customers
CREATE TABLE DimCustomers (
    DimCustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    CityName VARCHAR(100)
);

-- Dimension: Accounts
CREATE TABLE DimAccounts (
    DimAccountID INT AUTO_INCREMENT PRIMARY KEY,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    Balance DECIMAL(12,2) DEFAULT 0.00,
    OpenDate DATE
);



-- Dimension: Account Types
CREATE TABLE DimAccountTypes (
    DimAccountTypeID INT AUTO_INCREMENT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL
);

-- Fact Table: Transactions
CREATE TABLE FactTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(50) NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Description TEXT,

    DimCustomerID INT,
    DimAccountID INT,
    DimAccountTypeID INT,

    FOREIGN KEY (DimCustomerID) REFERENCES DimCustomers(DimCustomerID),
    FOREIGN KEY (DimAccountID) REFERENCES DimAccounts(DimAccountID),
    FOREIGN KEY (DimAccountTypeID) REFERENCES DimAccountTypes(DimAccountTypeID)
);

-- indekset
-- Index on DimCustomers.CityName
CREATE INDEX IX_DimCustomers_CityName
ON DimCustomers (CityName);

-- Index on DimCustomers.LastName
CREATE INDEX IX_DimCustomers_LastName
ON DimCustomers (LastName);

-- Index on DimAccounts.AccountNumber
CREATE INDEX IX_DimAccounts_AccountNumber
ON DimAccounts (AccountNumber);

-- Index on DimAccountTypes.TypeName
CREATE INDEX IX_DimAccountTypes_TypeName
ON DimAccountTypes (TypeName);

DELIMITER //

CREATE PROCEDURE autodataflow()
BEGIN
    -- Disable foreign key checks
    SET FOREIGN_KEY_CHECKS = 0;

    TRUNCATE TABLE DimCustomers;
    INSERT INTO DimCustomers (DimCustomerID, FirstName, LastName, CityName)
    SELECT ROW_NUMBER() OVER(ORDER BY c.CustomerID) AS DimCustomerID,
           c.FirstName, c.LastName, ci.CityName
    FROM BankDB.Customers c
    JOIN BankDB.Cities ci ON c.CityID = ci.CityID;

    TRUNCATE TABLE DimAccounts;
    INSERT INTO DimAccounts (DimAccountID, AccountNumber, Balance, OpenDate)
    SELECT ROW_NUMBER() OVER(ORDER BY a.AccountID) AS DimAccountID,
           a.AccountNumber, a.Balance, a.OpenDate
    FROM BankDB.Accounts a;

    TRUNCATE TABLE DimAccountTypes;
    INSERT INTO DimAccountTypes (DimAccountTypeID, TypeName)
    SELECT at.AccountTypeID, at.TypeName
    FROM BankDB.AccountTypes at;

    TRUNCATE TABLE FactTransactions;
    INSERT INTO FactTransactions (TransactionID, AccountID, TransactionType, Amount, TransactionDate, Description, DimCustomerID, DimAccountID, DimAccountTypeID)
    SELECT t.TransactionID, t.AccountID, t.TransactionType, t.Amount, t.TransactionDate, t.Description,
           c.CustomerID, a.AccountID, at.AccountTypeID
    FROM BankDB.Transactions t
    JOIN BankDB.Accounts a ON t.AccountID = a.AccountID
    JOIN BankDB.AccountTypes at ON a.AccountTypeID = at.AccountTypeID
    JOIN BankDB.Customers c ON a.CustomerID = c.CustomerID;

    -- Re-enable foreign key checks
    SET FOREIGN_KEY_CHECKS = 1;
END //

DELIMITER ;

-- global scheduleri
SET GLOBAL event_scheduler = ON;

-- eventi
CREATE EVENT IF NOT EXISTS ev_autodataflow
ON SCHEDULE EVERY 5 MINUTE
DO
  CALL autodataflow();
  
  -- me u shfaqe krejt eventet
  SHOW EVENTS;




