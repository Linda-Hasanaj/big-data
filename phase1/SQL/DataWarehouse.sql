CREATE DATABASE DWH_BankDB;
USE DWH_BankDB;


CREATE TABLE DimCustomers (
    DimCustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    CityName VARCHAR(100)
);



CREATE TABLE DimAccounts (
    DimAccountID INT PRIMARY KEY,
    AccountNumber VARCHAR(20),
    Balance DECIMAL(12,2),
    OpenDate DATE
);



CREATE TABLE DimAccountTypes (
    DimAccountTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50)
);



CREATE TABLE FactTransactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(50),
    Amount DECIMAL(12,2),
    TransactionDate DATETIME,
    Description TEXT,

    DimCustomerID INT,
    DimAccountID INT,
    DimAccountTypeID INT
);

CREATE NONCLUSTERED INDEX IX_DimCustomers_CityName
ON DimCustomers (CityName);

CREATE NONCLUSTERED INDEX IX_DimCustomers_LastName
ON DimCustomers (LastName);

CREATE NONCLUSTERED INDEX IX_DimAccounts_AccountNumber
ON DimAccounts (AccountNumber);


CREATE NONCLUSTERED INDEX IX_DimAccountTypes_TypeName
ON DimAccountTypes (TypeName);



