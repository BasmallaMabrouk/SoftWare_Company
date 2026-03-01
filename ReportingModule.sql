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
    P.PayrollID,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    P.Month,
    P.Year,
    P.BasicSalary,
    AT.AllowanceName,
    PA.Amount AS AllowanceAmount,
    DT.DeductionName,
    PD.Amount AS DeductionAmount,
    dbo.FN_TotalAllowances(P.PayrollID) AS TotalAllowances,
    dbo.FN_TotalDeductions(P.PayrollID) AS TotalDeductions,
    dbo.FN_NetSalary(P.PayrollID) AS NetSalary

FROM Payroll P
JOIN Employee E ON P.EmployeeID = E.EmployeeID
LEFT JOIN PayrollAllowance PA ON P.PayrollID = PA.PayrollID
LEFT JOIN AllowanceType AT ON PA.AllowanceTypeID = AT.AllowanceTypeID
LEFT JOIN PayrollDeduction PD ON P.PayrollID = PD.PayrollID
LEFT JOIN DeductionType DT ON PD.DeductionTypeID = DT.DeductionTypeID

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
