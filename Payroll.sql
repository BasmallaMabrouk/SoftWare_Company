ALTER TABLE Payroll
DROP COLUMN Deductions;

CREATE TABLE DeductionType
(
    DeductionTypeID INT PRIMARY KEY IDENTITY,
    DeductionName NVARCHAR(100) NOT NULL
);

INSERT INTO DeductionType (DeductionName)
VALUES 
('Tax'),
('Insurance'),
('Late'),
('Loan');

CREATE TABLE PayrollDeduction
(
    PayrollID INT,
    DeductionTypeID INT,
    Amount DECIMAL(10,2),

    PRIMARY KEY (PayrollID, DeductionTypeID),

    FOREIGN KEY (PayrollID) REFERENCES Payroll(PayrollID),
    FOREIGN KEY (DeductionTypeID) REFERENCES DeductionType(DeductionTypeID)
);

INSERT INTO PayrollDeduction VALUES (1,1,500); 
INSERT INTO PayrollDeduction VALUES (1,2,300); 
INSERT INTO PayrollDeduction VALUES (1,4,200); 

ALTER TABLE Payroll
DROP COLUMN Allowances;

CREATE TABLE AllowanceType
(
    AllowanceTypeID INT PRIMARY KEY IDENTITY,
    AllowanceName NVARCHAR(100)
);

CREATE TABLE PayrollAllowance
(
    PayrollID INT,
    AllowanceTypeID INT,
    Amount DECIMAL(10,2),

    PRIMARY KEY (PayrollID, AllowanceTypeID),

    FOREIGN KEY (PayrollID) REFERENCES Payroll(PayrollID),
    FOREIGN KEY (AllowanceTypeID) REFERENCES AllowanceType(AllowanceTypeID)
);

INSERT INTO AllowanceType (AllowanceName)
VALUES 
('Transportation'),
('Housing'),
('Medical'),
('Overtime'),
('Bonus');

INSERT INTO PayrollAllowance (PayrollID, AllowanceTypeID, Amount)
VALUES
(1, 1, 1000.00),  
(1, 2, 3000.00),  
(1, 4, 500.00),   
(2, 1, 800.00),   
(2, 3, 1200.00),  
(3, 5, 2000.00); 

CREATE PROCEDURE SP_AddPayrollAllowance
(
    @PayrollID INT,
    @AllowanceTypeID INT,
    @Amount DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO PayrollAllowance
    VALUES (@PayrollID, @AllowanceTypeID, @Amount)
END

CREATE PROCEDURE SP_AddPayrollDeduction
(
    @PayrollID INT,
    @DeductionTypeID INT,
    @Amount DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO PayrollDeduction
    VALUES (@PayrollID, @DeductionTypeID, @Amount)
END

CREATE OR ALTER PROCEDURE SP_CreatePayroll
(
    @EmployeeID INT,
    @Month INT,
    @Year INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Payroll
        WHERE EmployeeID = @EmployeeID
        AND [Month] = @Month
        AND [Year] = @Year
    )
    BEGIN
        RAISERROR('Payroll already exists.',16,1)
        RETURN
    END

    DECLARE @BasicSalary DECIMAL(10,2)

    SELECT @BasicSalary = Salary
    FROM Employee
    WHERE EmployeeID = @EmployeeID

    IF @BasicSalary IS NULL
    BEGIN
        RAISERROR('Employee not found.',16,1)
        RETURN
    END

    INSERT INTO Payroll
    (EmployeeID, [Month], [Year], BasicSalary, PaymentDate)
    VALUES
    (@EmployeeID, @Month, @Year, @BasicSalary, GETDATE())

	DECLARE @NewPayrollID INT
    SET @NewPayrollID = SCOPE_IDENTITY()

    EXEC SP_ApplyLateDeduction @NewPayrollID
END

CREATE OR ALTER FUNCTION FN_TotalAllowances(@PayrollID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2)

    SELECT @Total = ISNULL(SUM(Amount),0)
    FROM PayrollAllowance
    WHERE PayrollID = @PayrollID

    RETURN @Total
END

CREATE OR ALTER FUNCTION FN_TotalDeductions(@PayrollID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2)

    SELECT @Total = ISNULL(SUM(Amount),0)
    FROM PayrollDeduction
    WHERE PayrollID = @PayrollID

    RETURN @Total
END

CREATE OR ALTER FUNCTION FN_NetSalary(@PayrollID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Basic DECIMAL(10,2)
    DECLARE @Allow DECIMAL(10,2)
    DECLARE @Deduct DECIMAL(10,2)

    SELECT @Basic = BasicSalary
    FROM Payroll
    WHERE PayrollID = @PayrollID

    SET @Allow = dbo.FN_TotalAllowances(@PayrollID)
    SET @Deduct = dbo.FN_TotalDeductions(@PayrollID)

    RETURN @Basic + @Allow - @Deduct
END

CREATE OR ALTER VIEW V_PayrollSummary
AS
SELECT 
    P.PayrollID,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    P.Month,
    P.Year,
    P.BasicSalary,
    dbo.FN_TotalAllowances(P.PayrollID) AS TotalAllowances,
    dbo.FN_TotalDeductions(P.PayrollID) AS TotalDeductions,
    dbo.FN_NetSalary(P.PayrollID) AS NetSalary
FROM Payroll P
JOIN Employee E
ON P.EmployeeID = E.EmployeeID

CREATE PROCEDURE SP_GetEmployeePayHistory
(
    @EmployeeID INT
)
AS
BEGIN
    SELECT *
    FROM V_PayrollSummary
    WHERE EmployeeName IN
    (
        SELECT FirstName + ' ' + LastName
        FROM Employee
        WHERE EmployeeID = @EmployeeID
    )
END

EXEC SP_CreatePayroll 
    @EmployeeID = 5,
    @Month = 2,
    @Year = 2025;

EXEC SP_AddPayrollAllowance
    @PayrollID = 16,
    @AllowanceTypeID = 1,
    @Amount = 1000;

EXEC SP_AddPayrollDeduction
    @PayrollID = 16,
    @DeductionTypeID = 3,
    @Amount = 200;

SELECT * 
FROM V_PayrollSummary
WHERE PayrollID = 16;

EXEC SP_GetEmployeePayHistory 5;

CREATE OR ALTER PROCEDURE SP_ApplyLateDeduction
(
    @PayrollID INT
)
AS
BEGIN
    DECLARE @EmployeeID INT
    DECLARE @Month INT
    DECLARE @Year INT
    DECLARE @LateDays INT
    DECLARE @LateAmount DECIMAL(10,2)

    SELECT 
        @EmployeeID = EmployeeID,
        @Month = [Month],
        @Year = [Year]
    FROM Payroll
    WHERE PayrollID = @PayrollID

    SELECT @LateDays = COUNT(*)
    FROM Attendance
    WHERE EmployeeID = @EmployeeID
      AND Status = 'Late'
      AND MONTH([Date]) = @Month
      AND YEAR([Date]) = @Year

    SET @LateAmount = ISNULL(@LateDays,0) * 50

    IF @LateAmount > 0
    BEGIN
        INSERT INTO PayrollDeduction
        (PayrollID, DeductionTypeID, Amount)
        VALUES
        (@PayrollID, 3, @LateAmount)
    END
END

EXEC SP_ApplyLateDeduction 4;

SELECT * FROM PayrollDeduction d join Payroll p
ON d.PayrollID = p.PayrollID
WHERE d.PayrollID = 17;

INSERT INTO Attendance (EmployeeID,[Date],CheckIn,CheckOut,Status)
VALUES (6,'2025-02-01','09:20','17:00','Late'),
	   (6,'2025-02-03','09:15','17:00','Late')
;

EXEC SP_CreatePayroll 6, 2, 2025;

SELECT * 
FROM PayrollDeduction
WHERE PayrollID = (SELECT MAX(PayrollID) FROM Payroll);