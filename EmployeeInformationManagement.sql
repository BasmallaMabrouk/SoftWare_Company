ALTER TABLE Employee
ADD CONSTRAINT CHK_Employee_Gender
CHECK (Gender IN ('Female', 'Male'));


ALTER PROCEDURE SP_AddEmployee
(
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @Gender NVARCHAR(10) = NULL,
    @DateOfBirth DATE = NULL,
    @Email NVARCHAR(150) = NULL,
    @Address NVARCHAR(200) = NULL,
    @HireDate DATE = NULL,
    @Salary DECIMAL(10,2) = NULL,
    @Status NVARCHAR(50) = NULL,
    @DepartmentID INT,
    @PositionID INT
)
AS
BEGIN
    INSERT INTO Employee
    (FirstName, LastName, Gender, DateOfBirth, Email, Address, HireDate, Salary, Status, DepartmentID, PositionID)
    VALUES
    (@FirstName, @LastName, @Gender, @DateOfBirth, @Email, @Address, @HireDate, @Salary, @Status, @DepartmentID, @PositionID)
END

EXEC SP_AddEmployee
    @FirstName = 'Gehad',
    @LastName = 'Ahmed',
    @Gender = 'Female',
    @DateOfBirth = '2003-03-26',
    @Email = 'gehad@it.com',
    @Address = 'Giza',
    @HireDate = '2021-03-10',
    @Salary = 19000,
    @Status = 'Active',
    @DepartmentID = 2,
    @PositionID = 2;

EXEC SP_AddEmployee 'Heba', 'Ali', 'Female', '1996-01-05', 'heba@company.com', 'Cairo', '2023-01-10', 6200, 'Active', 1, 1
EXEC SP_AddEmployee 'Amr', 'Samy', 'Male', '1995-03-12', 'amr@company.com', 'Giza', '2022-05-20', 7100, 'Active', 2, 2
EXEC SP_AddEmployee 'Nada', 'Fady', 'Female', '1997-07-22', 'nada@company.com', 'Alex', '2023-03-15', 6800, 'Active', 3, 3
EXEC SP_AddEmployee 'Karim', 'Adel', 'Male', '1994-09-18', 'karim@company.com', 'Cairo', '2021-11-01', 7500, 'Active', 4, 4
EXEC SP_AddEmployee 'Mai', 'Hossam', 'Female', '1998-04-02', 'mai@company.com', 'Giza', '2022-07-11', 6400, 'Active', 5, 5
EXEC SP_AddEmployee 'Taha', 'Ramy', 'Male', '1993-12-25', 'taha@company.com', 'Alex', '2021-01-05', 7000, 'Active', 6, 6
EXEC SP_AddEmployee 'Reem', 'Ashraf', 'Female', '1996-06-30', 'reem@company.com', 'Cairo', '2023-02-20', 6600, 'Active', 7, 7
EXEC SP_AddEmployee 'Basma', 'Sayed', 'Female', '1995-08-14', 'basma@company.com', 'Giza', '2022-09-09', 6800, 'Active', 8, 8
EXEC SP_AddEmployee 'Ziad', 'Nour', 'Male', '1992-11-11', 'ziad@company.com', 'Alex', '2021-06-01', 7200, 'Active', 9, 9
EXEC SP_AddEmployee 'Aya', 'Lotfy', 'Female', '1997-05-05', 'aya@company.com', 'Cairo', '2023-01-25', 6500, 'Active', 10, 10

INSERT INTO EmployeePhone
VALUES(16, '01523456789')

CREATE PROCEDURE SP_UpdateEmployee
(
	@EmployeeID INT,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @Gender NVARCHAR(10) = NULL,
    @DateOfBirth DATE = NULL,
    @Email NVARCHAR(150) = NULL,
    @Address NVARCHAR(200) = NULL,
    @HireDate DATE = NULL,
    @Salary DECIMAL(10,2) = NULL,
    @Status NVARCHAR(50) = NULL,
    @DepartmentID INT = NULL,
    @PositionID INT = NULL
)
AS
BEGIN
UPDATE Employee 
SET FirstName = COALESCE(@FirstName, FirstName),
	LastName = COALESCE(@LastName, LastName),
	Gender = COALESCE(@Gender, Gender),
	DateOfBirth = COALESCE(@DateOfBirth, DateOfBirth),
	Email = COALESCE(@Email, Email),
	Address = COALESCE(@Address, Address),
	HireDate = COALESCE(@HireDate, HireDate),
	Salary = COALESCE(@Salary, Salary),
	Status = COALESCE(@Status, Status),
	DepartmentID = COALESCE(@DepartmentID, DepartmentID),
	PositionID = COALESCE(@PositionID, PositionID)
WHERE EmployeeID = @EmployeeID;
END

EXEC SP_UpdateEmployee
    @EmployeeID = 3,
    @Email = 'omar.updated@company.com'

CREATE PROCEDURE SP_DeleteEmployee
(
    @EmployeeID INT
)
AS
BEGIN
    DELETE FROM EmployeePhone WHERE EmployeeID = @EmployeeID;
    DELETE FROM EmploymentHistory WHERE EmployeeID = @EmployeeID;

    DELETE FROM Employee WHERE EmployeeID = @EmployeeID;
END


CREATE FUNCTION FN_CalcAge (@BirthDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @BirthDate, GETDATE())
           - CASE 
               WHEN MONTH(@BirthDate) > MONTH(GETDATE())
                    OR (MONTH(@BirthDate) = MONTH(GETDATE()) AND DAY(@BirthDate) > DAY(GETDATE()))
               THEN 1
               ELSE 0
             END
END


ALTER VIEW VW_EmployeeFullDetails
AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Gender,
    dbo.FN_CalcAge(e.DateOfBirth) AS Age,
    e.Email,
    e.Address,
    e.HireDate,
    e.Salary,
    e.Status,
    d.DepartmentName,
    p.PositionName,
    p.Grade,
    p.BaseSalary AS PositionBaseSalary,
    ep.Phone
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DepartmentID
JOIN Position p ON e.PositionID = p.PositionID
LEFT JOIN EmployeePhone ep ON e.EmployeeID = ep.EmployeeID;

SELECT * FROM VW_EmployeeFullDetails
WHERE EmployeeID = 3;

--PERSONAL INFO

CREATE VIEW VW_EmployeePersonalDetails
AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    DateOfBirth,
    dbo.FN_CalcAge(DateOfBirth) AS Age,
    Address,
    HireDate,
    Status
FROM Employee;

--Job Details
CREATE VIEW VW_EmployeeJobDetails
AS
SELECT 
    e.EmployeeID,
    d.DepartmentName,
    p.PositionName,
    p.Grade,
    e.Salary,
    p.BaseSalary AS PositionBaseSalary
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DepartmentID
JOIN Position p ON e.PositionID = p.PositionID;

--Contact Details
CREATE VIEW VW_EmployeeContactDetails
AS
SELECT 
    e.EmployeeID,
    e.Email,
    ep.Phone
FROM Employee e
LEFT JOIN EmployeePhone ep ON e.EmployeeID = ep.EmployeeID;

SELECT * FROM VW_EmployeePersonalDetails
WHERE EmployeeID = 16;

SELECT * FROM VW_EmployeeJobDetails
WHERE EmployeeID = 16;

SELECT * FROM VW_EmployeeContactDetails
WHERE EmployeeID = 16;


--Employment history 
CREATE PROCEDURE SP_AddEmploymentHistory
(
	@EmployeeID int,
	@DepartmentID int,
	@PositionID int,
	@StartDate DATE
)
AS
BEGIN
	UPDATE EmploymentHistory
	SET EndDate = DATEADD(DAY, -1, @StartDate)
    WHERE EmployeeID = @EmployeeID AND EndDate IS NULL;

	INSERT INTO EmploymentHistory
	VALUES (@EmployeeID, @DepartmentID, @PositionID, @StartDate, NULL)
END

ALTER VIEW VW_EmploymentHistory
AS
SELECT eh.HistoryID,
	   e.EmployeeID,
       e.FirstName + ' ' + e.LastName AS EmployeeName,
       d.DepartmentName,
       p.PositionName,
       eh.StartDate,
       eh.EndDate
FROM EmploymentHistory eh
JOIN Employee e ON eh.EmployeeID = e.EmployeeID
JOIN Department d ON eh.DepartmentID = d.DepartmentID
JOIN Position p ON eh.PositionID = p.PositionID;

EXEC SP_AddEmploymentHistory
    @EmployeeID = 3,
    @DepartmentID = 5,
    @PositionID = 5,
    @StartDate = '2025-02-01';

SELECT * FROM VW_EmploymentHistory
WHERE EmployeeID = 1;