CREATE DATABASE BankDB;
USE BankDB;

-- 1. Qytetet
CREATE TABLE Cities (
    CityID INT PRIMARY KEY AUTO_INCREMENT,
    CityName VARCHAR(100)
);

-- 2. Degët bankare
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

-- 3. Klientët
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PersonalNumber VARCHAR(20),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(150),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

-- 4. Punonjësit
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 5. Tipet e llogarive
CREATE TABLE AccountTypes (
    AccountTypeID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(50)
);

-- 6. Llogaritë bankare
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AccountNumber VARCHAR(20) UNIQUE,
    Balance DECIMAL(12,2),
    AccountTypeID INT,
    OpenDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);

-- 7. Kufizimet për llogaritë
CREATE TABLE AccountLimits (
    AccountTypeID INT PRIMARY KEY,
    DailyWithdrawalLimit DECIMAL(12,2),
    DailyTransferLimit DECIMAL(12,2),
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);

-- 8. Normat e interesit
CREATE TABLE InterestRates (
    RateID INT PRIMARY KEY AUTO_INCREMENT,
    AccountTypeID INT,
    InterestRate DECIMAL(5,2),
    EffectiveFrom DATE,
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);

-- 9. Transaksionet
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount DECIMAL(12,2),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Description TEXT,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 10. Kartat
CREATE TABLE Cards (
    CardID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    CardNumber VARCHAR(20) UNIQUE,
    CardType ENUM('Physical', 'Virtual'),
    ExpiryDate DATE,
    CVV VARCHAR(5),
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 11. Kreditë
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
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
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    LoanID INT,
    AmountPaid DECIMAL(12,2),
    PaymentDate DATE,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- 13. Llogaritë e kursimit
CREATE TABLE SavingsAccounts (
    SavingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Balance DECIMAL(12,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 14. Pagesat automatike
CREATE TABLE AutoPayments (
    AutoPaymentID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    Amount DECIMAL(12,2),
    PayeeName VARCHAR(100),
    Frequency VARCHAR(20),
    NextPaymentDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 15. Pagesat e shërbimeve
CREATE TABLE ServicePayments (
    ServicePaymentID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    ServiceProvider VARCHAR(100),
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 16. UserLogins për klientët
CREATE TABLE UserLogins (
    LoginID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Username VARCHAR(50) UNIQUE,
    PasswordHash VARCHAR(255),
    LastLogin TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 17. Përdoruesit e sistemit (adminë, menaxherë, etj)
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(50)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(255),
    RoleID INT,
    EmployeeID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- 18. Historia e hyrjeve në sistem
CREATE TABLE LoginHistory (
    LoginID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    LoginTime DATETIME,
    LogoutTime DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 19. Auditimi i veprimeve në sistem
CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Action VARCHAR(100),
    Details TEXT,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 20. Përfituesit (Beneficiaries)
CREATE TABLE Beneficiaries (
    BeneficiaryID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    BeneficiaryName VARCHAR(100),
    AccountNumber VARCHAR(20),
    BankName VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 1. Qytetet
INSERT INTO Cities (CityName) VALUES 
('Tiranë'), 
('Prishtinë'), 
('Shkodër'), 
('Mitrovicë'), 
('Durrës');

-- 2. Degët bankare
INSERT INTO Branches (BranchName, CityID) VALUES 
('Degë Qendrore', 1), 
('Degë Prishtinë', 2), 
('Degë Shkodër', 3), 
('Degë Mitrovicë', 4), 
('Degë Durrës', 5);

-- 3. Klientët
INSERT INTO Customers (FirstName, LastName, PersonalNumber, Email, Phone, Address, CityID) VALUES 
('Linda', 'Hasanaj', '1234567890123', 'linda.hasanaj@example.com', '0456789012', 'Rruga e Dajti, Tiranë', 1),
('Ardian', 'Shala', '9876543210987', 'ardian.shala@example.com', '0441234567', 'Rruga e Dajti, Prishtinë', 2),
('Emira', 'Bajrami', '1122334455667', 'emira.bajrami@example.com', '0498765432', 'Rruga e Rilindjes, Shkodër', 3);

-- 4. Punonjësit
INSERT INTO Employees (FirstName, LastName, Position, BranchID) VALUES 
('Florim', 'Nesimi', 'Menaxher', 1),
('Dajana', 'Hoxha', 'Përgjegjës Shitjesh', 2),
('Mirela', 'Shahu', 'Specialist i Llogarive', 3);

-- 5. Tipet e llogarive
INSERT INTO AccountTypes (TypeName) VALUES 
('Llogari Kurantore'), 
('Llogari Kursimi'), 
('Llogari Studentore');

-- 6. Llogaritë bankare
INSERT INTO Accounts (CustomerID, AccountNumber, Balance, AccountTypeID, OpenDate) VALUES 
(1, 'ACC123456', 1500.00, 1, '2023-01-15'),
(2, 'ACC654321', 2500.00, 2, '2022-12-10'),
(3, 'ACC112233', 500.00, 3, '2023-02-01');

-- 7. Kufizimet për llogaritë
INSERT INTO AccountLimits (AccountTypeID, DailyWithdrawalLimit, DailyTransferLimit) VALUES 
(1, 1000.00, 500.00),
(2, 500.00, 200.00),
(3, 200.00, 100.00);

-- 8. Normat e interesit
INSERT INTO InterestRates (AccountTypeID, InterestRate, EffectiveFrom) VALUES 
(2, 2.5, '2023-01-01'), 
(1, 1.0, '2023-02-01');

-- 9. Transaksionet
INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate, Description) VALUES 
(1, 'Depozitim', 500.00, '2023-03-10', 'Depozitë nga puna'),
(2, 'Tërheqje', 100.00, '2023-03-11', 'Pagesë për shërbime'),
(3, 'Depozitim', 200.00, '2023-03-12', 'Kursim i studentëve');

-- 10. Kartat
INSERT INTO Cards (AccountID, CardNumber, CardType, ExpiryDate, CVV) VALUES 
(1, '1234567890123456', 'Physical', '2025-05-01', '123'),
(2, '6543210987654321', 'Virtual', '2024-11-01', '456');

-- 11. Kreditë
INSERT INTO Loans (CustomerID, BranchID, Amount, InterestRate, TermMonths, IssueDate, Status) VALUES 
(1, 1, 10000.00, 5.0, 24, '2023-01-01', 'Approved'),
(2, 2, 5000.00, 6.0, 12, '2023-02-15', 'Pending');

-- 12. Pagesat e kredive
INSERT INTO LoanPayments (LoanID, AmountPaid, PaymentDate) VALUES 
(1, 500.00, '2023-02-10'),
(2, 400.00, '2023-03-15');

-- 13. Llogaritë e kursimit
INSERT INTO SavingsAccounts (CustomerID, Balance, InterestRate, StartDate) VALUES 
(1, 2000.00, 2.0, '2023-01-10'),
(3, 1500.00, 3.0, '2023-02-01');

-- 14. Pagesat automatike
INSERT INTO AutoPayments (AccountID, Amount, PayeeName, Frequency, NextPaymentDate) VALUES 
(1, 200.00, 'Shërbimi TV', 'Monthly', '2023-04-01'),
(2, 50.00, 'Shërbimi internet', 'Monthly', '2023-03-20');

-- 15. Pagesat e shërbimeve
INSERT INTO ServicePayments (AccountID, ServiceProvider, Amount, PaymentDate) VALUES 
(1, 'Albtelecom', 150.00, '2023-03-01'),
(2, 'IPKO', 80.00, '2023-03-10');

-- 16. UserLogins për klientët
INSERT INTO UserLogins (CustomerID, Username, PasswordHash, LastLogin) VALUES 
(1, 'linda.hasanaj', 'hashedpassword1', '2023-03-01 12:00:00'),
(2, 'ardian.shala', 'hashedpassword2', '2023-03-02 15:30:00');

-- 17. Përdoruesit e sistemit (adminë, menaxherë, etj)
INSERT INTO Roles (RoleName) VALUES 
('Admin'),
('Menaxher'),
('Përgjegjës Shitjesh');

INSERT INTO Users (Username, PasswordHash, RoleID, EmployeeID) VALUES 
('admin', 'adminpasswordhash', 1, 1),
('menaxher', 'managerpasswordhash', 2, 2);

-- 18. Historia e hyrjeve në sistem
INSERT INTO LoginHistory (UserID, LoginTime, LogoutTime) VALUES 
(1, '2023-03-01 12:00:00', '2023-03-01 12:30:00'),
(2, '2023-03-02 15:30:00', '2023-03-02 16:00:00');

-- 19. Auditimi i veprimeve në sistem
INSERT INTO AuditLog (UserID, Action, Details) VALUES 
(1, 'Krijim i llogarisë', 'Krijimi i llogarisë për klientin Linda Hasanaj'),
(2, 'Miratim i kredive', 'Miratimi i kredive për klientin Ardian Shala');

-- 20. Përfituesit (Beneficiaries)
INSERT INTO Beneficiaries (CustomerID, BeneficiaryName, AccountNumber, BankName) VALUES 
(1, 'Erion Hoxha', 'ACC654321', 'Banka e Tiranës'),
(2, 'Aida Shala', 'ACC112233', 'Banka e Prishtinës');



