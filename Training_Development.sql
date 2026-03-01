-- View: Show employees with their training details
CREATE VIEW vw_TrainingDetails AS
SELECT 
    E.EmployeeID,
    E.FirstName + ' ' + E.LastName AS FullName,
    T.TrainingName,
    T.StartDate,
    T.EndDate,
    ET.CompletionStatus,
    ET.Certificate,
    ET.Score
FROM Employee E
JOIN Employee_Training ET ON E.EmployeeID = ET.EmployeeID
JOIN Training T ON T.TrainingID = ET.TrainingID;




SELECT * FROM vw_TrainingDetails;





-- View: Show training schedule with trainer name
CREATE VIEW vw_TrainingSchedule AS
SELECT 
    T.TrainingID,
    T.TrainingName,
    T.StartDate,
    T.EndDate,
    E.FirstName + ' ' + E.LastName AS TrainerName
FROM Training T
JOIN Employee E ON T.TrainerID = E.EmployeeID;



SELECT * FROM vw_TrainingSchedule;



-- View: Employees who completed training and got certificate
CREATE VIEW vw_CompletedTrainings AS
SELECT 
    E.EmployeeID,
    E.FirstName + ' ' + E.LastName AS FullName,
    T.TrainingName,
    ET.Score
FROM Employee E
JOIN Employee_Training ET ON E.EmployeeID = ET.EmployeeID
JOIN Training T ON T.TrainingID = ET.TrainingID
WHERE ET.CompletionStatus = 'Completed'
AND ET.Certificate = 'Yes';


SELECT * FROM vw_CompletedTrainings;




-- Procedure: Assign employee to training
CREATE PROCEDURE sp_AssignEmployeeTraining
    @EmployeeID INT,
    @TrainingID INT,
    @CompletionStatus NVARCHAR(50),
    @Certificate NVARCHAR(100),
    @Score DECIMAL(5,2)
AS
BEGIN
    INSERT INTO Employee_Training
    VALUES (@EmployeeID, @TrainingID, @CompletionStatus, @Certificate, @Score);
END;


EXEC sp_AssignEmployeeTraining 1,2,'Completed','Yes',88;




-- Procedure: Get employees in specific training
CREATE PROCEDURE sp_GetTrainingEmployees
    @TrainingID INT
AS
BEGIN
    SELECT 
        E.EmployeeID,
        E.FirstName + ' ' + E.LastName AS FullName,
        ET.CompletionStatus,
        ET.Score
    FROM Employee E
    JOIN Employee_Training ET ON E.EmployeeID = ET.EmployeeID
    WHERE ET.TrainingID = @TrainingID;
END;



EXEC sp_GetTrainingEmployees 1;



-- Procedure: Update employee training score
CREATE PROCEDURE sp_UpdateTrainingScore
    @EmployeeID INT,
    @TrainingID INT,
    @NewScore DECIMAL(5,2)
AS
BEGIN
    UPDATE Employee_Training
    SET Score = @NewScore
    WHERE EmployeeID = @EmployeeID
    AND TrainingID = @TrainingID;
END;



EXEC sp_UpdateTrainingScore 1,1,95;