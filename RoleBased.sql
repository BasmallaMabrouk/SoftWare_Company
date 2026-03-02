USE CompanyDatabse;
GO

-- Create Roles
CREATE ROLE HR;
CREATE ROLE Manager;
CREATE ROLE Admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Admin;
GRANT EXECUTE ON SCHEMA::dbo TO Admin;

-- Employee Management
GRANT SELECT, INSERT, UPDATE ON Employee TO HR;
GRANT SELECT, INSERT, UPDATE ON EmployeePhone TO HR;
GRANT SELECT, INSERT, UPDATE ON EmploymentHistory TO HR;

-- Attendance & Leave
GRANT SELECT, INSERT, UPDATE ON Attendance TO HR;
GRANT SELECT, INSERT, UPDATE ON LeaveRequest TO HR;

-- Payroll
GRANT SELECT, INSERT, UPDATE ON Payroll TO HR;
GRANT SELECT, INSERT, UPDATE ON PayrollAllowance TO HR;
GRANT SELECT, INSERT, UPDATE ON PayrollDeduction TO HR;

GRANT EXECUTE ON SP_CreatePayroll TO HR;
GRANT EXECUTE ON SP_AddPayrollAllowance TO HR;
GRANT EXECUTE ON SP_AddPayrollDeduction TO HR;

-- Training
GRANT SELECT ON Training TO HR;
GRANT SELECT ON Employee_Training TO HR;

-- Views (Reports)
GRANT SELECT ON vw_EmployeeMasterList TO HR;
GRANT SELECT ON vw_PayrollReport TO HR;
GRANT SELECT ON vw_AttendanceSummary TO HR;
GRANT SELECT ON vw_LeaveBalance TO HR;
GRANT SELECT ON vw_TrainingPerformance TO HR;


-- View only employee data
GRANT SELECT ON Employee TO Manager;
GRANT SELECT ON EmployeePhone TO Manager;

-- Attendance
GRANT SELECT ON Attendance TO Manager;

-- Leave Approval
GRANT SELECT, UPDATE ON LeaveRequest TO Manager;
GRANT EXECUTE ON ApproveLeave TO Manager;
GRANT EXECUTE ON RejectLeave TO Manager;

-- Payroll View Only
GRANT SELECT ON vw_PayrollReport TO Manager;

-- Reports
GRANT SELECT ON vw_EmployeeMasterList TO Manager;
GRANT SELECT ON vw_AttendanceSummary TO Manager;
GRANT SELECT ON vw_LeaveBalance TO Manager;
GRANT SELECT ON vw_TrainingPerformance TO Manager;

-- Create Logins
CREATE LOGIN HR_User WITH PASSWORD = 'Hr123';
CREATE LOGIN Manager_User WITH PASSWORD = 'Manager123';
CREATE LOGIN Admin_User WITH PASSWORD = 'Admin123';


CREATE USER HR_User FOR LOGIN HR_User;
CREATE USER Manager_User FOR LOGIN Manager_User;
CREATE USER Admin_User FOR LOGIN Admin_User;

ALTER ROLE HR ADD MEMBER HR_User;
ALTER ROLE Manager ADD MEMBER Manager_User;
ALTER ROLE Admin ADD MEMBER Admin_User;


INSERT INTO UserAccount (Username, Password, Role, EmployeeID)
VALUES
('gehad', '123', 'Admin', 16),
('heba', '123', 'Employee', 17),
('amr', '123', 'Manager', 18),
('nada', '123', 'Admin', 19),
('karim', '123', 'HR', 20),
('mai', '123', 'HR', 21),
('taha', '123', 'Employee', 22),
('reem', '123', 'Employee', 23),
('basma', '123', 'Employee', 24),
('ziad', '123', 'Employee', 25),
('aya', '123', 'Manager', 26);


CREATE LOGIN Gehad_Login WITH PASSWORD = '123';
CREATE LOGIN Heba_Login WITH PASSWORD = '123';
CREATE LOGIN Amr_Login WITH PASSWORD = '123';
CREATE LOGIN Nada_Login WITH PASSWORD = '123';
CREATE LOGIN Karim_Login WITH PASSWORD = '123';
CREATE LOGIN Mai_Login WITH PASSWORD = '123';
CREATE LOGIN Taha_Login WITH PASSWORD = '123';
CREATE LOGIN Reem_Login WITH PASSWORD = '123';
CREATE LOGIN Basma_Login WITH PASSWORD = '123';
CREATE LOGIN Ziad_Login WITH PASSWORD = '123';
CREATE LOGIN Aya_Login WITH PASSWORD = '123';

CREATE USER Gehad_User FOR LOGIN Gehad_Login;
CREATE USER Heba_User FOR LOGIN Heba_Login;
CREATE USER Amr_User FOR LOGIN Amr_Login;
CREATE USER Nada_User FOR LOGIN Nada_Login;
CREATE USER Karim_User FOR LOGIN Karim_Login;
CREATE USER Mai_User FOR LOGIN Mai_Login;
CREATE USER Taha_User FOR LOGIN Taha_Login;
CREATE USER Reem_User FOR LOGIN Reem_Login;
CREATE USER Basma_User FOR LOGIN Basma_Login;
CREATE USER Ziad_User FOR LOGIN Ziad_Login;
CREATE USER Aya_User FOR LOGIN Aya_Login;

CREATE ROLE EmployeeRole;
GRANT SELECT ON VW_EmployeeProfile TO EmployeeRole;

DENY SELECT ON Payroll TO EmployeeRole;
DENY SELECT ON Attendance TO EmployeeRole;
DENY SELECT ON LeaveRequest TO EmployeeRole;
DENY SELECT ON Employee TO EmployeeRole;

-- Admins
ALTER ROLE Admin ADD MEMBER Gehad_User;
ALTER ROLE Admin ADD MEMBER Nada_User;

-- Employees
ALTER ROLE EmployeeRole ADD MEMBER Heba_User;
ALTER ROLE EmployeeRole ADD MEMBER Taha_User;
ALTER ROLE EmployeeRole ADD MEMBER Reem_User;
ALTER ROLE EmployeeRole ADD MEMBER Basma_User;
ALTER ROLE EmployeeRole ADD MEMBER Ziad_User;

-- Managers
ALTER ROLE Manager ADD MEMBER Amr_User;
ALTER ROLE Manager ADD MEMBER Aya_User;

-- HR
ALTER ROLE HR ADD MEMBER Karim_User;
ALTER ROLE HR ADD MEMBER Mai_User;

CREATE OR ALTER VIEW VW_EmployeeProfile
AS
SELECT E.EmployeeID, E.FirstName, E.LastName, E.Gender, E.DateOfBirth,
       E.Email, E.Address, E.HireDate, E.Salary, E.Status,
       D.DepartmentName, P.PositionName
FROM Employee E
JOIN Department D ON E.DepartmentID = D.DepartmentID
JOIN Position P ON E.PositionID = P.PositionID
JOIN UserAccount U ON E.EmployeeID = U.EmployeeID
WHERE U.Username = USER_NAME() 
  AND U.Role = 'Employee';

CREATE OR ALTER PROCEDURE SP_GetMyProfile
AS
BEGIN
    SELECT *
    FROM VW_EmployeeProfile
END

GRANT EXECUTE ON ApplyLeave TO EmployeeRole;
GRANT EXECUTE ON CheckIn TO EmployeeRole;
GRANT EXECUTE ON CheckOut TO EmployeeRole;
GRANT SELECT ON VW_EmployeeProfile TO EmployeeRole;


