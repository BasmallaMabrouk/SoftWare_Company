CREATE VIEW vw_EmployeeMasterList AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Gender,
    e.DateOfBirth,
    e.Email,
    e.Address,
    e.HireDate,
    e.Salary,
    e.Status,
    d.DepartmentName,
    p.PositionName,
    p.Grade
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DepartmentID
JOIN Position p ON e.PositionID = p.PositionID;

select * from vw_EmployeeMasterList










CREATE VIEW vw_AttendanceSummary AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(a.AttendanceID) AS TotalDays,
    SUM(CASE WHEN a.Status = 'Present' THEN 1 ELSE 0 END) AS PresentDays,
    SUM(CASE WHEN a.Status = 'Late' THEN 1 ELSE 0 END) AS LateDays,
    SUM(CASE WHEN a.Status != 'Present' AND a.Status != 'Late' THEN 1 ELSE 0 END) AS AbsentDays
FROM Attendance a
JOIN Employee e ON a.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

select * from vw_AttendanceSummary


CREATE VIEW vw_PayrollReport AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    p.BasicSalary,
    p.Allowances,
    p.Deductions,
    (p.BasicSalary + p.Allowances - p.Deductions) AS NetSalary,
    p.PaymentDate
FROM Payroll p
JOIN Employee e ON p.EmployeeID = e.EmployeeID;

select * from vw_PayrollReport


CREATE VIEW vw_LeaveBalance AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(l.LeaveID) AS TotalLeaves,
    SUM(CASE WHEN l.Status = 'Approved' THEN DATEDIFF(DAY, l.StartDate, l.EndDate) + 1 ELSE 0 END) AS ApprovedLeaveDays,
    SUM(CASE WHEN l.Status = 'Pending' THEN DATEDIFF(DAY, l.StartDate, l.EndDate) + 1 ELSE 0 END) AS PendingLeaveDays
FROM LeaveRequest l
JOIN Employee e ON l.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

select * from vw_LeaveBalance


CREATE VIEW vw_TrainingPerformance AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    t.TrainingName,
    et.CompletionStatus,
    et.Score,
    p.Rating,
    p.Comments
FROM Employee e
LEFT JOIN Employee_Training et ON e.EmployeeID = et.EmployeeID
LEFT JOIN Training t ON et.TrainingID = t.TrainingID
LEFT JOIN Performance p ON e.EmployeeID = p.EmployeeID;

select * from vw_TrainingPerformance