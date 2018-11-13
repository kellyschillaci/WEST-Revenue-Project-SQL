/*
	Author: Kelly Schillaci
	Course: IST659
	Term: July 2018
*/
-- Creating the User Table

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WESTClientAccountingService')
BEGIN
	DROP TABLE WESTClientAccountingService
END
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WESTClientAncillaryService')
BEGIN
	DROP TABLE WESTClientAncillaryService
END
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WESTClient')
BEGIN
	DROP TABLE WESTClient
END
GO






IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AccountingService')
BEGIN
	DROP TABLE AccountingService
END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ContractedAncillaryService')
BEGIN
	DROP TABLE ContractedAncillaryService
END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AncillaryService')
BEGIN
	DROP TABLE AncillaryService
END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Employee')
BEGIN
	DROP TABLE Employee
END
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE NAME = 'DeleteWESTClient')
BEGIN
	DROP PROCEDURE DeleteWESTClient
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE NAME = 'TotalWESTRevenue')
BEGIN 
	DROP VIEW TotalWESTRevenue
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE NAME = 'WESTClientRevenue')
BEGIN 
	DROP VIEW WESTClientRevenue
END
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE NAME = 'ChangeAccountManager')
BEGIN
	DROP Procedure ChangeAccountManager
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE NAME = 'WESTClientIDlookup')
BEGIN
	DROP FUNCTION WESTClientIDlookup
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE NAME = 'WESTClientByAccountManager')
BEGIN
	DROP VIEW WESTClientByAccountManager
END
GO





CREATE TABLE Employee (
	EmployeeID int identity NOT NULL,
	EmployeeFirstName varchar(20) NOT NULL,
	EmployeeLastName varchar(20) NOT NULL,
	JobTitle varchar(50) NOT NULL,
	CONSTRAINT pk_Employee PRIMARY KEY (EmployeeID)
)

CREATE TABLE AncillaryService (
	AncillaryServiceID int identity,
	AncillaryServiceDescription varchar(250),
	CONSTRAINT pk_AncilaryService PRIMARY KEY (AncillaryServiceID),
)

CREATE TABLE ContractedAncillaryService (
	ContractedAncillaryServiceID int identity,
	ContractedAncillaryServiceName varchar(50),
	AncillaryServiceID int NOT NULL,
	CONSTRAINT pk_ContractedAncillaryService PRIMARY KEY (ContractedAncillaryServiceID),
	CONSTRAINT FK1_ContractedAncillaryService FOREIGN KEY (AncillaryServiceID) REFERENCES AncillaryService(AncillaryServiceID)
)

CREATE TABLE AccountingService (
	AccountingServiceID int identity,
	AccountingServiceDescription varchar(250),
	CONSTRAINT pk_AccountingService PRIMARY KEY (AccountingServiceID),
)

CREATE TABLE WESTClient (
	WESTClientID int identity,
	CEOFirstName varchar(20) NOT NULL,
	CEOLastName varchar(20) NOT NULL,
	CompanyName varchar (50) NOT NULL,
	MonthlyFee money,
	EmployeeID int NOT NULL,
	CONSTRAINT pk_WESTClient PRIMARY KEY (WESTClientID),
	CONSTRAINT FK1_WESTClient FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),	
)

CREATE TABLE WESTClientAncillaryService (
	WESTClientAncillaryServiceID int identity,
	WESTClientID int NOT NULL,
	ContractedAncillaryServiceID int NOT NULL, 
	WissCommission money, 
	EmployeeID int NOT NULL
	CONSTRAINT pk_WESTClientAncillaryService PRIMARY KEY (WESTClientAncillaryServiceID),
	CONSTRAINT FK1_WESTClientAncillaryService FOREIGN KEY (WESTClientID) REFERENCES WESTClient(WESTClientID),
	CONSTRAINT FK2_WESTClientAncillaryService FOREIGN KEY (ContractedAncillaryServiceID) REFERENCES ContractedAncillaryService(ContractedAncillaryServiceID),
	CONSTRAINT FK3_WESTClientAncillaryService FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
)
SELECT ISNULL(WissCommission, 0 ) FROM WESTClientAncillaryService
CREATE TABLE WESTClientAccountingService (
	WESTClientAccountingServiceID int identity,
	WESTClientID int NOT NULL,
	AccountingServiceID int NOT NULL,
	WissFee money,
	EmployeeID int NOT NULL,
	CONSTRAINT pk_WESTClientAccountingService PRIMARY KEY (WESTClientAccountingServiceID),
	CONSTRAINT FK1_WESTClientAccountingService FOREIGN KEY (WESTClientID) REFERENCES WESTClient(WESTClientID),
	CONSTRAINT FK2_WESTClientAccountingService FOREIGN KEY (AccountingServiceID) REFERENCES AccountingService(AccountingServiceID),
	CONSTRAINT FK3_WESTClientAccountingService FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
)
SELECT ISNULL(WissFee, 0 ) FROM WESTClientAccountingService
INSERT INTO Employee (EmployeeFirstName, EmployeeLastName, JobTitle)
	VALUES
		('Kelly', 'Schillaci', 'Account Manager'),
		('Lauren', 'Stella', 'Account Manager'),
		('Mary', 'Pratt', 'Account Manager'),
		('Donna', 'Woronka', 'WEST Manager'),
		('Lisa', 'Greyenbuhl', 'CFO Manager'),
		('Tricia', 'Meola', 'CFO Accountant'),
		('Sean', 'Colrick', 'Director of Client Relations')


INSERT INTO AncillaryService (AncillaryServiceDescription)
	VALUES
		('Employee Benefits'),
		('Sales Commission'),
		('Recruiting'),
		('Technology Contract')

INSERT INTO ContractedAncillaryService (ContractedAncillaryServiceName, AncillaryServiceID)
	VALUES
		('Rootstrap', (SELECT AncillaryServiceID FROM AncillaryService WHERE AncillaryServiceDescription = 'Technology Contract')),
		('Oxford', (SELECT AncillaryServiceID FROM AncillaryService WHERE AncillaryServiceDescription = 'Employee Benefits')),
		('Cigna', (SELECT AncillaryServiceID FROM AncillaryService WHERE AncillaryServiceDescription = 'Employee Benefits')),
		('ADP', (SELECT AncillaryServiceID FROM AncillaryService WHERE AncillaryServiceDescription = 'Sales Commission')),
		('JustWorks', (SELECT AncillaryServiceID FROM AncillaryService WHERE AncillaryServiceDescription = 'Sales Commission'))
INSERT INTO AccountingService (AccountingServiceDescription)
	VALUES
		('GAAP Adjustments'),
		('Historical Cleanup'),
		('Payroll Tax Notices'),
		('CFO Advisory Services')


INSERT INTO WESTClient (CEOFirstName, CEOLastName, CompanyName, MonthlyFee, EmployeeID)
	VALUES
		('Keith', 'George', 'CoEdition', '900', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Schillaci')),
		('Danielle', 'Rylan', 'NWHL', '900', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Schillaci')),
		('Jacopo', 'Leonardi', 'Activcore', '5000', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Schillaci')),
		('Alex', 'Skove', 'KidGooRoo', '900', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Schillaci')),
		('Justin', 'Henry', 'Henry the Dentist', '900', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Stella')),
		('David', 'Smart', 'Shoowin', '1300', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Stella'))

INSERT INTO WESTClientAncillaryService (WESTClientID, ContractedAncillaryServiceID, WissCommission, EmployeeID)
	VALUES
		((SELECT WESTClientID FROM WESTClient WHERE CompanyName = 'NWHL'), (SELECT ContractedAncillaryServiceID FROM ContractedAncillaryService WHERE ContractedAncillaryServiceName = 'Cigna'), '500', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Colrick')),
		((SELECT WESTClientID FROM WESTClient WHERE CompanyName = 'Activcore'), (SELECT ContractedAncillaryServiceID FROM ContractedAncillaryService WHERE ContractedAncillaryServiceName = 'ADP'), '425', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Colrick'))


INSERT INTO WESTClientAccountingService (WESTClientID, AccountingServiceID, WissFee, EmployeeID)
	VALUES
		((SELECT WESTClientID FROM WESTClient WHERE CompanyName = 'Activcore'), (SELECT AccountingServiceID FROM AccountingService WHERE AccountingServiceDescription = 'CFO Advisory Services'), '7000', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Greyenbuhl')),
		((SELECT WESTClientID FROM WESTClient WHERE CompanyName = 'Shoowin'), (SELECT AccountingServiceID FROM AccountingService WHERE AccountingServiceDescription = 'GAAP Adjustments'), '3000', (SELECT EmployeeID FROM Employee WHERE EmployeeLastName = 'Woronka'))
----Find each client's Account Manager
GO
CREATE VIEW WESTClientByAccountManager AS
SELECT
	CompanyName,
	EmployeeFirstName,
	EmployeeLastName
	FROM WESTClient
	JOIN Employee ON WESTClient.EmployeeID = Employee.EmployeeID
GO
---Look up client ID

CREATE FUNCTION dbo.WESTClientIDlookup(@companyName varchar(50))
RETURNS int AS
BEGIN
	DECLARE @returnValue int
	SELECT @returnValue = WESTClientID FROM WESTClient
	WHERE CompanyName = @companyName
	RETURN @returnValue
END
GO

---Change Account Manager

CREATE PROCEDURE ChangeAccountManager (@EmployeeID int, @newEmployeeID int)
AS
BEGIN
	UPDATE WESTClient SET EmployeeID = @newEmployeeID
	WHERE EmployeeID = @EmployeeID
END
GO
---Client Revenue
GO
SELECT
	CompanyName
	, SUM(9*MonthlyFee) as YTDMonthlyFeeRevenue
	FROM WESTClient
	GROUP BY CompanyName, MonthlyFee
	ORDER BY YTDMonthlyFeeRevenue DESC
GO

---Client Revenue by Category
CREATE VIEW WESTClientRevenue AS
SELECT
	CompanyName
	, SUM(9*MonthlyFee) as YTDRevenue 
	, SUM(isnull(WissFee,0)) as YTDAccountingRevenue
	, SUM(isnull(WissCommission,0)) as YTDAncillaryRevenue
	FROM WESTClient
	LEFT JOIN WESTClientAccountingService ON WESTClientAccountingService.WESTClientID = WESTClient.WESTClientID
	LEFT JOIN WESTClientAncillaryService ON WESTClientAncillaryService.WESTClientID = WESTClient.WESTClientID
	GROUP BY CompanyName
GO

SELECT * FROM WESTClientRevenue
---Total 2018 WEST Revenue
GO
CREATE VIEW TotalWESTRevenue AS
SELECT CompanyName, 
	SUM(isnull(YTDRevenue,0)+isnull(YTDAccountingRevenue,0)+isnull(YTDAncillaryRevenue,0)) AS Total
FROM WESTClientRevenue
GROUP BY CompanyName, YTDRevenue, YTDAccountingRevenue, YTDAncillaryRevenue

GO

SELECT * FROM TotalWESTRevenue
GO
---Delete Client that does not renew service
CREATE PROCEDURE DeleteWESTClient (@WESTClientID int)
AS
BEGIN
	DELETE WESTClient 
	WHERE WESTClientID = @WESTClientID
END
GO
