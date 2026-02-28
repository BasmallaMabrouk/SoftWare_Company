CREATE PROCEDURE CheckIn
    @EmpID INT
AS
BEGIN
    INSERT INTO Attendance(EmployeeID,[Date],CheckIn,Status)
    VALUES
    (
        @EmpID,
        CAST(GETDATE() AS DATE),
        CAST(GETDATE() AS TIME),
        'Present'
    );
END;
EXEC CheckIn 2;

CREATE PROCEDURE CheckOut
    @EmpID INT
AS
BEGIN
    UPDATE Attendance
    SET CheckOut = CAST(GETDATE() AS TIME)
    WHERE EmployeeID = @EmpID
    AND [Date] = CAST(GETDATE() AS DATE);
END;
GO
EXEC CheckOut 2

CREATE VIEW AttendanceDetails AS
SELECT
    EmployeeID,
    [Date],
    CheckIn,
    CheckOut,
    DATEDIFF(MINUTE,CheckIn,CheckOut)/60.0 AS WorkingHours,
    Status
FROM Attendance;

CREATE PROCEDURE ApplyLeave
    @EmpID INT,
    @Type NVARCHAR(50),
    @Start DATE,
    @End DATE
AS
BEGIN
    INSERT INTO LeaveRequest
    (EmployeeID,LeaveType,StartDate,EndDate,Status)
    VALUES
    (@EmpID,@Type,@Start,@End,'Pending');
END;

EXEC ApplyLeave 2,'Annual','2025-03-01','2025-03-03';

--Manger accept
CREATE PROCEDURE ApproveLeave
    @LeaveID INT,
    @ManagerID INT
AS
BEGIN
    UPDATE LeaveRequest
    SET Status='Approved',
        ApprovedBy=@ManagerID
    WHERE LeaveID=@LeaveID;
END;

EXEC ApproveLeave 5,11;

CREATE PROCEDURE RejectLeave
    @LeaveID INT,
    @ManagerID INT
AS
BEGIN
    UPDATE LeaveRequest
    SET Status='Rejected',
        ApprovedBy=@ManagerID
    WHERE LeaveID=@LeaveID;
END;

CREATE VIEW LeaveBalance AS
SELECT
    E.EmployeeID,
    E.FirstName,
    21 -
    ISNULL(SUM(DATEDIFF(DAY,L.StartDate,L.EndDate)+1),0)
    AS RemainingLeave
FROM Employee E
LEFT JOIN LeaveRequest L
ON E.EmployeeID=L.EmployeeID
AND L.Status='Approved'
GROUP BY E.EmployeeID,E.FirstName;

SELECT * FROM LeaveBalance;