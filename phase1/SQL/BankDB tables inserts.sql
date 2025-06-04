USE BankDB;
GO

-- 1. Qytetet
CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName VARCHAR(100)
);

-- 2. Deg�t bankare
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName VARCHAR(100),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

-- 3. Klient�t
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PersonalNumber VARCHAR(20),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(150),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

-- 4. Punonj�sit
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 5. Tipet e llogarive
CREATE TABLE AccountTypes (
    AccountTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50)
);

-- 6. Llogarit� bankare
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    AccountNumber VARCHAR(20) UNIQUE,
    Balance DECIMAL(12,2),
    AccountTypeID INT,
    OpenDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);

-- 7. Kufizimet p�r llogarit�
CREATE TABLE AccountLimits (
    AccountTypeID INT PRIMARY KEY,
    DailyWithdrawalLimit DECIMAL(12,2),
    DailyTransferLimit DECIMAL(12,2),
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);

-- 8. Normat e interesit
CREATE TABLE InterestRates (
    RateID INT PRIMARY KEY IDENTITY(1,1),
    AccountTypeID INT,
    InterestRate DECIMAL(5,2),
    EffectiveFrom DATE,
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);

-- 9. Transaksionet
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount DECIMAL(12,2),
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Description TEXT,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 10. Kartat
CREATE TABLE Cards (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    CardNumber VARCHAR(20) UNIQUE,
    CardType VARCHAR(20),
    ExpiryDate DATE,
    CVV VARCHAR(5),
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CHECK (CardType IN ('Physical', 'Virtual'))
);

-- 11. Kredit�
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    BranchID INT,
    Amount DECIMAL(15,2),
    InterestRate DECIMAL(5,2),
    TermMonths INT,
    IssueDate DATE,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 12. Pagesat e kredive
CREATE TABLE LoanPayments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    LoanID INT,
    AmountPaid DECIMAL(12,2),
    PaymentDate DATE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- 13. Llogarit� e kursimit
CREATE TABLE SavingsAccounts (
    SavingID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    Balance DECIMAL(12,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 14. Pagesat automatike
CREATE TABLE AutoPayments (
    AutoPaymentID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    Amount DECIMAL(12,2),
    PayeeName VARCHAR(100),
    Frequency VARCHAR(20),
    NextPaymentDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 15. Pagesat e sh�rbimeve
CREATE TABLE ServicePayments (
    ServicePaymentID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    ServiceProvider VARCHAR(100),
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 16. UserLogins p�r klient�t
CREATE TABLE UserLogins (
    LoginID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    Username VARCHAR(50) UNIQUE,
    PasswordHash VARCHAR(255),
    LastLogin DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 17. Roli dhe p�rdoruesit e sistemit
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName VARCHAR(50)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50),
    PasswordHash VARCHAR(255),
    RoleID INT,
    EmployeeID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- 18. Historia e hyrjeve n� sistem
CREATE TABLE LoginHistory (
    LoginID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    LoginTime DATETIME,
    LogoutTime DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 19. Auditimi i veprimeve n� sistem
CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    Action VARCHAR(100),
    Details TEXT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 20. P�rfituesit (Beneficiaries)
CREATE TABLE Beneficiaries (
    BeneficiaryID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    BeneficiaryName VARCHAR(100),
    AccountNumber VARCHAR(20),
    BankName VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);




-- CITIES
INSERT INTO Cities (CityName) VALUES
('Prishtin�'),
('Gjakov�'),
('Pej�'),
('Prizren'),
('Mitrovic�');

-- BRANCHES
INSERT INTO Branches (BranchName, CityID) VALUES
('Dega Qendrore', 1),
('Dega Gjakov�', 2),
('Dega Pej�', 3),
('Dega Prizren', 4),
('Dega Mitrovic�', 5);

-- CUSTOMERS
INSERT INTO Customers (FirstName, LastName, PersonalNumber, Email, Phone, Address, CityID) VALUES
('Ardit', 'Berisha', '123456789', 'ardit@example.com', '049123456', 'Rruga A', 1),
('Luljeta', 'Krasniqi', '987654321', 'luljeta@example.com', '044987654', 'Rruga B', 2);

-- EMPLOYEES
INSERT INTO Employees (FirstName, LastName, Position, BranchID) VALUES
('Ilir', 'Rama', 'Menaxher', 1),
('Er�za', 'Morina', 'Zyrtare Kredie', 2);

-- ACCOUNT TYPES
INSERT INTO AccountTypes (TypeName) VALUES
('Rrjedh�se'),
('Kursimi');

-- ACCOUNTS
INSERT INTO Accounts (CustomerID, AccountNumber, Balance, AccountTypeID, OpenDate) VALUES
(1, '1000001', 1500.00, 1, '2023-01-01'),
(2, '1000002', 2500.50, 2, '2023-02-15');

-- ACCOUNT LIMITS
INSERT INTO AccountLimits (AccountTypeID, DailyWithdrawalLimit, DailyTransferLimit) VALUES
(1, 1000.00, 2000.00),
(2, 500.00, 1500.00);

-- INTEREST RATES
INSERT INTO InterestRates (AccountTypeID, InterestRate, EffectiveFrom) VALUES
(1, 0.50, '2023-01-01'),
(2, 1.20, '2023-01-01');

-- TRANSACTIONS
INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate, Description) VALUES
(1, 'Depozit�', 500.00, '2023-03-01', 'Rroga mujore'),
(1, 'T�rheqje', 100.00, '2023-03-02', 'ATM'),
(2, 'Depozit�', 1000.00, '2023-03-01', 'Pages� sh�rbimi');

-- CARDS
INSERT INTO Cards (AccountID, CardNumber, CardType, ExpiryDate, CVV, Status) VALUES
(1, '1111222233334444', 'Physical', '2026-01-01', '123', 'Active'),
(2, '5555666677778888', 'Virtual', '2025-12-31', '456', 'Active');

-- LOANS
INSERT INTO Loans (CustomerID, BranchID, Amount, InterestRate, TermMonths, IssueDate, Status) VALUES
(1, 1, 5000.00, 3.5, 24, '2023-01-15', 'Approved'),
(2, 2, 3000.00, 4.0, 12, '2023-03-01', 'Pending');

-- LOAN PAYMENTS
INSERT INTO LoanPayments (LoanID, AmountPaid, PaymentDate) VALUES
(1, 210.00, '2023-02-15'),
(1, 210.00, '2023-03-15');

-- SAVINGS ACCOUNTS
INSERT INTO SavingsAccounts (CustomerID, Balance, InterestRate, StartDate) VALUES
(1, 2000.00, 1.2, '2023-01-10');

-- AUTO PAYMENTS
INSERT INTO AutoPayments (AccountID, Amount, PayeeName, Frequency, NextPaymentDate) VALUES
(1, 50.00, 'KESCO', 'Mujor', '2023-04-10');

-- SERVICE PAYMENTS
INSERT INTO ServicePayments (AccountID, ServiceProvider, Amount, PaymentDate) VALUES
(2, 'IPKO', 25.00, '2023-03-05');

-- USER LOGINS
INSERT INTO UserLogins (CustomerID, Username, PasswordHash, LastLogin) VALUES
(1, 'arditb', 'hashed_password_1', GETDATE()),
(2, 'luljetak', 'hashed_password_2', GETDATE());

-- ROLES
INSERT INTO Roles (RoleName) VALUES
('Admin'),
('Zyrtar');

-- USERS
INSERT INTO Users (Username, PasswordHash, RoleID, EmployeeID) VALUES
('admin', 'admin_hash', 1, 1),
('kredit_zyrtar', 'zyrtar_hash', 2, 2);

-- LOGIN HISTORY
INSERT INTO LoginHistory (UserID, LoginTime, LogoutTime) VALUES
(1, '2023-04-01 08:00:00', '2023-04-01 16:00:00'),
(2, '2023-04-01 09:00:00', '2023-04-01 17:00:00');

-- AUDIT LOG
INSERT INTO AuditLog (UserID, Action, Details, Timestamp) VALUES
(1, 'Modifikim Klienti', 'Ndryshoi emailin e klientit Ardit', GETDATE());

-- BENEFICIARIES
INSERT INTO Beneficiaries (CustomerID, BeneficiaryName, AccountNumber, BankName) VALUES
(1, 'Blerina Hoxha', '1000005', 'Banka e Kosov�s');
