CREATE DATABASE CompanyDatabse;
GO

USE CompanyDatabse;
GO
CREATE TABLE Department
(
    DepartmentID INT PRIMARY KEY IDENTITY,
    DepartmentName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(150),
    ManagerID INT NULL
);
CREATE TABLE Position
(
    PositionID INT PRIMARY KEY IDENTITY,
    PositionName NVARCHAR(100) NOT NULL,
    Grade NVARCHAR(50),
    BaseSalary DECIMAL(10,2)
);
CREATE TABLE Employee
(
    EmployeeID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    Email NVARCHAR(150) UNIQUE,
    Address NVARCHAR(200),
    HireDate DATE,
    Salary DECIMAL(10,2),
    Status NVARCHAR(50),

    DepartmentID INT NOT NULL,
    PositionID INT NOT NULL,

    CONSTRAINT FK_Employee_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID),

    CONSTRAINT FK_Employee_Position
        FOREIGN KEY (PositionID)
        REFERENCES Position(PositionID)
);
CREATE TABLE EmployeePhone
(
    PhoneID INT PRIMARY KEY IDENTITY,
    EmployeeID INT,
    Phone NVARCHAR(20),

    CONSTRAINT FK_EmployeePhone_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);
CREATE TABLE Attendance
(
    AttendanceID INT PRIMARY KEY IDENTITY,
    EmployeeID INT NOT NULL,
    [Date] DATE,
    CheckIn TIME,
    CheckOut TIME,
    Status NVARCHAR(50),

    CONSTRAINT FK_Attendance_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);
CREATE TABLE LeaveRequest
(
    LeaveID INT PRIMARY KEY IDENTITY,
    EmployeeID INT NOT NULL,
    LeaveType NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(50),
    ApprovedBy INT NULL,

    CONSTRAINT FK_Leave_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),

    CONSTRAINT FK_Leave_ApprovedBy
        FOREIGN KEY (ApprovedBy)
        REFERENCES Employee(EmployeeID)
);
CREATE TABLE Payroll
(
    PayrollID INT PRIMARY KEY IDENTITY,
    EmployeeID INT NOT NULL,
    [Month] INT,
    [Year] INT,
    BasicSalary DECIMAL(10,2),
    Allowances DECIMAL(10,2),
    Deductions DECIMAL(10,2),
    PaymentDate DATE,

    CONSTRAINT FK_Payroll_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);
CREATE TABLE Performance
(
    PerformanceID INT PRIMARY KEY IDENTITY,
    EmployeeID INT NOT NULL,
    ReviewDate DATE,
    Rating INT,
    Comments NVARCHAR(500),
    ReviewedBy INT,
    ReviewPeriod NVARCHAR(50),

    CONSTRAINT FK_Performance_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),

    CONSTRAINT FK_Performance_Reviewer
        FOREIGN KEY (ReviewedBy)
        REFERENCES Employee(EmployeeID)
);
CREATE TABLE Training
(
    TrainingID INT PRIMARY KEY IDENTITY,
    TrainingName NVARCHAR(150),
    Description NVARCHAR(500),
    StartDate DATE,
    EndDate DATE,
    TrainerID INT,

    CONSTRAINT FK_Training_Trainer
        FOREIGN KEY (TrainerID)
        REFERENCES Employee(EmployeeID)
);
CREATE TABLE Employee_Training
(
    EmployeeID INT,
    TrainingID INT,
    CompletionStatus NVARCHAR(50),
    Certificate NVARCHAR(100),
    Score DECIMAL(5,2),

    CONSTRAINT PK_EmployeeTraining
        PRIMARY KEY (EmployeeID, TrainingID),

    CONSTRAINT FK_ET_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),

    CONSTRAINT FK_ET_Training
        FOREIGN KEY (TrainingID)
        REFERENCES Training(TrainingID)
);
CREATE TABLE Recruitment
(
    CandidateID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(150),
    Phone NVARCHAR(20),
    AppliedPositionID INT,
    ApplicationDate DATE,
    Status NVARCHAR(50),

    CONSTRAINT FK_Recruitment_Position
        FOREIGN KEY (AppliedPositionID)
        REFERENCES Position(PositionID)
);
CREATE TABLE UserAccount
(
    UserID INT PRIMARY KEY IDENTITY,
    Username NVARCHAR(50) UNIQUE,
    Password NVARCHAR(200),
    Role NVARCHAR(50),
    EmployeeID INT UNIQUE,

    CONSTRAINT FK_UserAccount_Employee
        FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);

CREATE TABLE EmploymentHistory
(
    HistoryID INT PRIMARY KEY IDENTITY,
    EmployeeID INT NOT NULL,
    DepartmentID INT NOT NULL,
    PositionID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL, 

    CONSTRAINT FK_EmpHist_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_EmpHist_Department FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    CONSTRAINT FK_EmpHist_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager
FOREIGN KEY (ManagerID)
REFERENCES Employee(EmployeeID);

INSERT INTO EmploymentHistory (EmployeeID, DepartmentID, PositionID, StartDate, EndDate)
VALUES
(1, 1, 1, '2022-01-01', '2023-01-01'),
(1, 2, 2, '2023-01-02', NULL),
(2, 2, 2, '2021-03-10', NULL),
(3, 3, 3, '2020-06-15', NULL);

INSERT INTO Department (DepartmentName, Location)
VALUES
('HR','Cairo'),
('IT','Giza'),
('Finance','Alex'),
('Marketing','Cairo'),
('Sales','Giza'),
('Support','Mansoura'),
('R&D','Cairo'),
('QA','Giza'),
('Security','Alex'),
('Admin','Cairo'),
('Operations','Giza'),
('Logistics','Suez'),
('Training','Cairo'),
('Legal','Alex'),
('Procurement','Giza');

INSERT INTO Position (PositionName, Grade, BaseSalary)
VALUES
('HR Specialist','G1',6000),
('Software Developer','G2',9000),
('Accountant','G2',7500),
('Marketing Officer','G1',6500),
('Sales Executive','G1',6200),
('Support Engineer','G1',6000),
('Researcher','G3',10000),
('QA Engineer','G2',8500),
('Security Officer','G1',5000),
('Administrator','G1',5500),
('Operations Manager','G4',12000),
('Logistics Officer','G1',5800),
('Trainer','G2',8000),
('Legal Advisor','G3',11000),
('Purchasing Officer','G1',6000);

INSERT INTO Employee
(FirstName,LastName,Gender,DateOfBirth,Email,Address,HireDate,Salary,Status,DepartmentID,PositionID)
VALUES
('Ahmed','Ali','Male','1995-02-10','ahmed@hr.com','Cairo','2022-01-01',6000,'Active',1,1),
('Sara','Hassan','Female','1997-05-12','sara@it.com','Giza','2021-03-10',9000,'Active',2,2),
('Omar','Khaled','Male','1994-07-20','omar@fin.com','Alex','2020-06-15',7500,'Active',3,3),
('Mona','Adel','Female','1996-01-11','mona@mark.com','Cairo','2023-02-01',6500,'Active',4,4),
('Ali','Mahmoud','Male','1993-09-05','ali@sales.com','Giza','2021-11-11',6200,'Active',5,5),
('Nour','Sameh','Female','1998-04-02','nour@sup.com','Mansoura','2022-07-01',6000,'Active',6,6),
('Youssef','Ibrahim','Male','1992-03-03','youssef@rnd.com','Cairo','2019-01-01',10000,'Active',7,7),
('Laila','Tarek','Female','1995-06-06','laila@qa.com','Giza','2020-10-10',8500,'Active',8,8),
('Hany','Fathy','Male','1990-12-12','hany@sec.com','Alex','2018-05-05',5000,'Active',9,9),
('Dina','Wael','Female','1999-08-08','dina@admin.com','Cairo','2023-01-15',5500,'Active',10,10),
('Kareem','Adham','Male','1991-02-22','kareem@ops.com','Giza','2017-03-03',12000,'Active',11,11),
('Rania','Nabil','Female','1996-04-18','rania@log.com','Suez','2022-09-09',5800,'Active',12,12),
('Mostafa','Said','Male','1994-11-11','mostafa@train.com','Cairo','2021-12-12',8000,'Active',13,13),
('Salma','Yasser','Female','1993-10-10','salma@legal.com','Alex','2019-07-07',11000,'Active',14,14),
('Tamer','Lotfy','Male','1997-03-15','tamer@proc.com','Giza','2024-01-01',6000,'Active',15,15);

INSERT INTO EmployeePhone (EmployeeID,Phone)
VALUES
(1,'0100000001'),(2,'0100000002'),(3,'0100000003'),
(4,'0100000004'),(5,'0100000005'),(6,'0100000006'),
(7,'0100000007'),(8,'0100000008'),(9,'0100000009'),
(10,'0100000010'),(11,'0100000011'),(12,'0100000012'),
(13,'0100000013'),(14,'0100000014'),(15,'0100000015');

INSERT INTO Attendance (EmployeeID,[Date],CheckIn,CheckOut,Status)
VALUES
(1,'2025-01-01','09:00','17:00','Present'),
(2,'2025-01-01','09:10','17:05','Present'),
(3,'2025-01-01','09:05','17:00','Present'),
(4,'2025-01-01','09:20','17:00','Late'),
(5,'2025-01-01','09:00','16:50','Present'),
(6,'2025-01-01','09:00','17:00','Present'),
(7,'2025-01-01','09:00','17:30','Present'),
(8,'2025-01-01','09:15','17:00','Late'),
(9,'2025-01-01','09:00','17:00','Present'),
(10,'2025-01-01','09:05','17:00','Present'),
(11,'2025-01-01','09:00','17:00','Present'),
(12,'2025-01-01','09:00','17:00','Present'),
(13,'2025-01-01','09:00','17:00','Present'),
(14,'2025-01-01','09:00','17:00','Present'),
(15,'2025-01-01','09:00','17:00','Present');

INSERT INTO LeaveRequest
(EmployeeID,LeaveType,StartDate,EndDate,Status,ApprovedBy)
VALUES
(1,'Annual','2025-02-01','2025-02-05','Approved',11),
(2,'Sick','2025-02-03','2025-02-04','Approved',11),
(3,'Annual','2025-02-10','2025-02-12','Pending',11),
(4,'Emergency','2025-02-15','2025-02-16','Approved',11),
(5,'Annual','2025-02-20','2025-02-22','Approved',11),
(6,'Sick','2025-02-05','2025-02-06','Approved',11),
(7,'Annual','2025-02-07','2025-02-09','Pending',11),
(8,'Annual','2025-02-11','2025-02-13','Approved',11),
(9,'Sick','2025-02-01','2025-02-02','Approved',11),
(10,'Annual','2025-02-14','2025-02-18','Pending',11),
(11,'Annual','2025-02-21','2025-02-23','Approved',11),
(12,'Emergency','2025-02-24','2025-02-25','Approved',11),
(13,'Annual','2025-02-26','2025-02-28','Pending',11),
(14,'Sick','2025-02-08','2025-02-09','Approved',11),
(15,'Annual','2025-02-17','2025-02-19','Approved',11);

INSERT INTO Payroll
(EmployeeID,[Month],[Year],BasicSalary,Allowances,Deductions,PaymentDate)
VALUES
(1,1,2025,6000,500,200,'2025-01-30'),
(2,1,2025,9000,700,300,'2025-01-30'),
(3,1,2025,7500,400,200,'2025-01-30'),
(4,1,2025,6500,300,100,'2025-01-30'),
(5,1,2025,6200,200,150,'2025-01-30'),
(6,1,2025,6000,200,100,'2025-01-30'),
(7,1,2025,10000,800,400,'2025-01-30'),
(8,1,2025,8500,500,250,'2025-01-30'),
(9,1,2025,5000,200,100,'2025-01-30'),
(10,1,2025,5500,200,100,'2025-01-30'),
(11,1,2025,12000,1000,500,'2025-01-30'),
(12,1,2025,5800,200,100,'2025-01-30'),
(13,1,2025,8000,400,200,'2025-01-30'),
(14,1,2025,11000,700,300,'2025-01-30'),
(15,1,2025,6000,200,100,'2025-01-30');

INSERT INTO Performance
(EmployeeID,ReviewDate,Rating,Comments,ReviewedBy,ReviewPeriod)
VALUES
(1,'2025-01-10',4,'Good',11,'2024'),
(2,'2025-01-10',5,'Excellent',11,'2024'),
(3,'2025-01-10',3,'Average',11,'2024'),
(4,'2025-01-10',4,'Good',11,'2024'),
(5,'2025-01-10',3,'Needs improvement',11,'2024'),
(6,'2025-01-10',4,'Good',11,'2024'),
(7,'2025-01-10',5,'Outstanding',11,'2024'),
(8,'2025-01-10',4,'Good',11,'2024'),
(9,'2025-01-10',3,'Average',11,'2024'),
(10,'2025-01-10',4,'Good',11,'2024'),
(11,'2025-01-10',5,'Leader',11,'2024'),
(12,'2025-01-10',4,'Good',11,'2024'),
(13,'2025-01-10',4,'Good',11,'2024'),
(14,'2025-01-10',5,'Excellent',11,'2024'),
(15,'2025-01-10',3,'Average',11,'2024');

INSERT INTO Training
(TrainingName,Description,StartDate,EndDate,TrainerID)
VALUES
('Leadership','Management skills','2025-03-01','2025-03-05',11),
('SQL','Database Training','2025-03-10','2025-03-15',2),
('HR Basics','HR Processes','2025-03-20','2025-03-22',1),
('Marketing','Digital Marketing','2025-04-01','2025-04-03',4),
('Security','Cyber Basics','2025-04-05','2025-04-07',9),
('QA','Testing','2025-04-10','2025-04-12',8),
('Finance','Accounting','2025-04-15','2025-04-17',3),
('Sales','Negotiation','2025-04-20','2025-04-22',5),
('Support','Customer Care','2025-04-25','2025-04-27',6),
('Research','Innovation','2025-05-01','2025-05-05',7),
('Admin','Office Mgmt','2025-05-10','2025-05-12',10),
('Legal','Contracts','2025-05-15','2025-05-17',14),
('Logistics','Supply Chain','2025-05-20','2025-05-22',12),
('Training Skills','Teaching','2025-05-25','2025-05-27',13),
('Procurement','Purchasing','2025-06-01','2025-06-03',15);

INSERT INTO Employee_Training
(EmployeeID,TrainingID,CompletionStatus,Certificate,Score)
VALUES
(1,1,'Completed','Yes',90),
(2,2,'Completed','Yes',95),
(3,3,'Completed','Yes',85),
(4,4,'Completed','Yes',88),
(5,5,'Completed','Yes',80),
(6,6,'Completed','Yes',87),
(7,7,'Completed','Yes',92),
(8,8,'Completed','Yes',84),
(9,9,'Completed','Yes',78),
(10,10,'Completed','Yes',86),
(11,11,'Completed','Yes',93),
(12,12,'Completed','Yes',82),
(13,13,'Completed','Yes',89),
(14,14,'Completed','Yes',94),
(15,15,'Completed','Yes',83);

INSERT INTO Recruitment
(FirstName,LastName,Email,Phone,AppliedPositionID,ApplicationDate,Status)
VALUES
('Heba','Ali','heba@mail.com','0111',1,'2025-01-01','Pending'),
('Amr','Samy','amr@mail.com','0112',2,'2025-01-02','Accepted'),
('Nada','Fady','nada@mail.com','0113',3,'2025-01-03','Rejected'),
('Karim','Adel','karim@mail.com','0114',4,'2025-01-04','Pending'),
('Mai','Hossam','mai@mail.com','0115',5,'2025-01-05','Accepted'),
('Taha','Ramy','taha@mail.com','0116',6,'2025-01-06','Pending'),
('Reem','Ashraf','reem@mail.com','0117',7,'2025-01-07','Rejected'),
('Basma','Sayed','basma@mail.com','0118',8,'2025-01-08','Pending'),
('Ziad','Nour','ziad@mail.com','0119',9,'2025-01-09','Accepted'),
('Aya','Lotfy','aya@mail.com','0120',10,'2025-01-10','Pending'),
('Fares','Ali','fares@mail.com','0121',11,'2025-01-11','Pending'),
('Salem','Kamal','salem@mail.com','0122',12,'2025-01-12','Rejected'),
('Mira','Nabil','mira@mail.com','0123',13,'2025-01-13','Accepted'),
('Hager','Yassin','hager@mail.com','0124',14,'2025-01-14','Pending'),
('Walid','Sameh','walid@mail.com','0125',15,'2025-01-15','Accepted');

INSERT INTO UserAccount (Username,Password,Role,EmployeeID)
VALUES
('ahmed','123','HR',1),
('sara','123','Developer',2),
('omar','123','Accountant',3),
('mona','123','Marketing',4),
('ali','123','Sales',5),
('nour','123','Support',6),
('youssef','123','Research',7),
('laila','123','QA',8),
('hany','123','Security',9),
('dina','123','Admin',10),
('kareem','123','Manager',11),
('rania','123','Logistics',12),
('mostafa','123','Trainer',13),
('salma','123','Legal',14),
('tamer','123','Procurement',15);