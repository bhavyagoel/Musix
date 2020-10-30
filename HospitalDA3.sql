CREATE DATABASE IF NOT EXISTS Hospital;

USE Hospital;

# Q1 Create all tables in Hospital database as per the requirement.

CREATE TABLE IF NOT EXISTS Doctor
(
    Doc_ID        CHAR(5)                             NOT NULL PRIMARY KEY UNIQUE CHECK ( Doc_ID LIKE 'D%'),
    Doc_Name      VARCHAR(15)                         NOT NULL,
    Gender        CHAR,
    DOB           DATE,
    Specialist    VARCHAR(15),
    Qualification VARCHAR(15),
    Contact       VARCHAR(20)                         NOT NULL,
    Address       TEXT,
    Dept_No       CHAR(5) CHECK ( Dept_No LIKE 'DE%') NOT NULL
);

CREATE TABLE IF NOT EXISTS Department
(
    Dept_No   CHAR(5) CHECK ( Dept_No LIKE 'DE%') NOT NULL PRIMARY KEY UNIQUE,
    Dept_Name VARCHAR(15)                         NOT NULL,
    Room_No   INT,
    Floor     INT,
    HOD       CHAR(5)                             NOT NULL CHECK ( HOD LIKE 'D%' ),
    Estd_Date DATE CHECK ( Estd_Date >= '2010-01-01')
);

CREATE TABLE Staff
(
    Staff_ID    CHAR(5)                             NOT NULL CHECK ( Staff_ID LIKE 'S%' ) PRIMARY KEY UNIQUE,
    Staff_Name  VARCHAR(15)                         NOT NULL,
    Category    VARCHAR(15),
    Designation VARCHAR(20),
    DOB         DATE,
    Contact     VARCHAR(20),
    Address     TEXT,
    Dept_No     CHAR(5) CHECK ( Dept_No LIKE 'DE%') NOT NULL
);

CREATE TABLE IF NOT EXISTS Patient
(
    Pat_ID   CHAR(5) NOT NULL CHECK ( Pat_ID LIKE 'P%' ) PRIMARY KEY UNIQUE,
    Pat_Name VARCHAR(15),
    DOB      DATE,
    Gender   CHAR,
    Contact  VARCHAR(20),
    Address  TEXT
);

CREATE TABLE IF NOT EXISTS In_Patient
(
    Pat_ID            CHAR(5) NOT NULL CHECK ( Pat_ID LIKE 'P%' ) PRIMARY KEY UNIQUE,
    Date_of_Admission DATE    NOT NULL,
    Bed_No            INT     NOT NULL,
    Start_Time        TIME    NOT NULL,
    End_Time          TIME    NOT NULL
);

CREATE TABLE IF NOT EXISTS In_Patient_Prescription
(
    Pat_ID  CHAR(5) NOT NULL CHECK ( Pat_ID LIKE 'P%' ) UNIQUE,
    Pres_ID CHAR(7) NOT NULL CHECK ( Pres_ID LIKE 'PR%' ) UNIQUE
);

CREATE TABLE IF NOT EXISTS Appointment
(
    App_ID          CHAR(7) NOT NULL CHECK ( App_ID LIKE 'AP%' ) UNIQUE PRIMARY KEY,
    Pat_ID          CHAR(5) NOT NULL CHECK ( Pat_ID LIKE 'P%' ) UNIQUE,
    Doc_ID          CHAR(5) NOT NULL UNIQUE CHECK ( Doc_ID LIKE 'D%'),
    Nurse_ID        CHAR(7) NOT NULL UNIQUE CHECK ( Nurse_ID LIKE 'S%'),
    Consult_Room_No INT(3)  NOT NULL,
    Date            DATE    NOT NULL,
    Time            TIME    NOT NULL
);

CREATE TABLE IF NOT EXISTS Prescription
(
    Pres_ID          CHAR(7) NOT NULL CHECK ( Pres_ID LIKE 'PR%' ) UNIQUE PRIMARY KEY,
    App_ID           CHAR(7) NOT NULL CHECK ( App_ID LIKE 'AP%' ) UNIQUE,
    Date             DATE,
    Time             TIME,
    Diagnosis_Detail TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS Prescribed_Medicines
(
    Pres_ID       CHAR(7)     NOT NULL CHECK ( Pres_ID LIKE 'PR%' ) UNIQUE PRIMARY KEY,
    Medicine_Name VARCHAR(20) NOT NULL,
    Dosage        VARCHAR(20) NOT NULL,
    Brand         VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Hospital_Bill
(
    Inv_No       INT(11) NOT NULL UNIQUE PRIMARY KEY,
    Inv_Date     DATE    NOT NULL,
    Pat_ID       CHAR(5) NOT NULL CHECK ( Pat_ID LIKE 'P%' ) UNIQUE,
    Bill_Amount  FLOAT   NOT NULL,
    Payment_Type VARCHAR(15),
    Discount     FLOAT
);

CREATE TABLE IF NOT EXISTS Lab_Tests
(
    Test_ID CHAR(7) NOT NULL CHECK ( Test_ID LIKE 'TE%' ) UNIQUE PRIMARY KEY,
    Pat_ID  CHAR(5) NOT NULL CHECK ( Pat_ID LIKE 'P%' ) UNIQUE,
    Date    DATE,
    Time    TIME
);

CREATE TABLE IF NOT EXISTS Test_Results
(
    Test_ID CHAR(7)     NOT NULL CHECK ( Test_ID LIKE 'TE%' ) UNIQUE PRIMARY KEY,
    TT_ID   VARCHAR(15) NOT NULL,
    Result  TEXT        NOT NULL
);

CREATE TABLE IF NOT EXISTS Test_Types
(
    TT_ID       VARCHAR(15) NOT NULL PRIMARY KEY UNIQUE,
    Description TEXT,
    Low_Value   INT         NOT NULL,
    High_Value  INT         NOT NULL,
    Test_Method Text,
    Technician  CHAR(5)     NOT NULL CHECK ( Technician LIKE 'S%' ) UNIQUE
);

ALTER TABLE Doctor
    ADD FOREIGN KEY (Dept_No) REFERENCES Department (Dept_No);

ALTER TABLE Department
    ADD FOREIGN KEY (HOD) REFERENCES Doctor (Doc_ID);

ALTER TABLE Staff
    ADD FOREIGN KEY (Dept_No) REFERENCES Department (Dept_No);

ALTER TABLE In_Patient
    ADD FOREIGN KEY (Pat_ID) REFERENCES Patient (Pat_ID);

ALTER TABLE In_Patient_Prescription
    ADD FOREIGN KEY (Pat_ID) REFERENCES Patient (Pat_ID),
    ADD FOREIGN KEY (Pres_ID) REFERENCES Prescription (Pres_ID);

ALTER TABLE Appointment
    ADD FOREIGN KEY (Pat_ID) REFERENCES Patient (Pat_ID),
    ADD FOREIGN KEY (Doc_ID) REFERENCES Doctor (Doc_ID),
    ADD FOREIGN KEY (Nurse_ID) REFERENCES Staff (Staff_ID);

ALTER TABLE Prescription
    ADD FOREIGN KEY (App_ID) REFERENCES Appointment (App_ID);

ALTER TABLE Prescribed_Medicines
    ADD FOREIGN KEY (Pres_ID) REFERENCES Prescription (Pres_ID);

ALTER TABLE Hospital_Bill
    ADD FOREIGN KEY (Pat_ID) REFERENCES Patient (Pat_ID);

ALTER TABLE Lab_Tests
    ADD FOREIGN KEY (Pat_ID) REFERENCES Patient (Pat_ID);

ALTER TABLE Test_Results
    ADD FOREIGN KEY (Test_ID) REFERENCES Lab_Tests (Test_ID),
    ADD FOREIGN KEY (TT_ID) REFERENCES Test_Types (TT_ID);

ALTER TABLE Test_Types
    ADD FOREIGN KEY (Technician) REFERENCES Staff (Staff_ID);

INSERT INTO Patient (Pat_ID, Pat_Name, DOB, Gender, Contact, Address)
VALUES ('P0001', 'Rahul Gupta', '2011-01-01', 'M', 9517534568, 'Ghaziabad'),
       ('P0002', 'Sanjay Sinha', '1999-12-23', 'M', 8524567531, 'Delhi'),
       ('P0003', 'Rajeev Kumar', '1978-08-01', 'M', 9654231578, 'Gurgaon'),
       ('P0004', 'Prakash Mishra', '2011-01-01', 'M', 9575684260, 'Lucknow'),
       ('P0005', 'Sweety Gupta', '2011-01-01', 'F', 7586945162, 'Ghaziabad'),
       ('P0006', 'Pinky Agarwal', '2011-01-01', 'F', 7598426135, 'Delhi');

INSERT INTO In_Patient (Pat_ID, Date_of_Admission, Bed_No, Start_Time, End_Time)
VALUES ('P0001', '2020-02-23', 345, '8:47:13', '23:56:12'),
       ('P0002', '2020-05-01', 100, '6:43:16', '23:56:12'),
       ('P0003', '2020-07-15', 312, '2:56:12', '23:56:12'),
       ('P0004', '2020-08-01', 345, '8:47:13', '10:53:13'),
       ('P0005', '2019-12-23', 145, '3:13:12', '23:56:12'),
       ('P0006', '2018-10-31', 178, '8:47:13', '7:34:13');

INSERT INTO Lab_Tests (Test_ID, Pat_ID, Date, Time)
VALUES ('TE0001', 'P0002', '2020-05-12', '8:43:16'),
       ('TE0002', 'P0003', '2020-07-15', '8:34:16'),
       ('TE0003', 'P0005', '2019-12-23', '15:25:16'),
       ('TE0004', 'P0006', '2018-10-31', '13:27:16'),
       ('TE0005', 'P0001', '2020-02-23', '9:32:16'),
       ('TE0006', 'P0004', '2020-08-01', '10:42:16');

INSERT INTO Hospital_Bill (Inv_No, Inv_Date, Pat_ID, Bill_Amount, Payment_Type, Discount)
VALUES ('1264358965', '2019-12-23', 'P0005', 85890, 'Insurance', 0),
       ('1264678965', '2020-05-12', 'P0002', 8653, 'Cash', 5),
       ('1598568587', '2018-10-31', 'P0006', 102689, 'Card', 10),
       ('1598842687', '2020-07-15', 'P0003', 105439, 'Card', 12),
       ('1598426587', '2020-08-01', 'P0004', 96523, 'Card', 8),
       ('1578987587', '2020-02-23', 'P0001', 45826, 'Card', 3);

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO Department (Dept_No, Dept_Name, Room_No, Floor, HOD, Estd_Date)
VALUES ('DE006', 'Cardiology', 123, 1, 'D0003', '2011-05-12'),
       ('DE003', 'ICU', 243, 2, 'D0006', '2010-07-12'),
       ('DE002', 'Oncology', 156, 1, 'D0001', '2010-10-23'),
       ('DE004', 'Neurology', 343, 3, 'D0005', '2012-05-12'),
       ('DE005', 'Obstetrics', 456, 4, 'D0002', '2013-12-15'),
       ('DE001', 'Diabetes', 043, 0, 'D0004', '2010-09-12');

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Doctor (Doc_ID, Doc_Name, Gender, DOB, Specialist, Qualification, Contact, Address, Dept_No)
VALUES ('D0001', 'Deepak Agarwal', 'M', '1970-02-03', 'Diabetes', 'MBBS', 9514236589, 'Ghaziabad', 'DE001'),
       ('D0002', 'Pankaj Agarwal', 'M', '1979-04-23', 'Ophthalmology', 'MD', 7245631892, 'Ghaziabad', 'DE002'),
       ('D0003', 'Rakesh Mohan', 'M', '1989-10-13', 'Cardiology', 'MD', 8546231548, 'Delhi', 'DE003'),
       ('D0004', 'Shweta Tiwari', 'F', '1990-07-01', 'Neurology', 'BDS', 8751263548, 'Gurugram', 'DE004'),
       ('D0005', 'Gopal Agarwal', 'M', '1975-12-18', 'Diabetes', 'MD', 'Ghaziabad', 9514235789, 'DE001'),
       ('D0006', 'Lokesh Tripathi', 'M', '1987-06-20', 'Cardiology', 'MBBS', 7541236085, 'Lucknow', 'DE003');


INSERT INTO Staff (Staff_ID, Staff_Name, Category, Designation, DOB, Contact, Address, Dept_No)
VALUES ('S0001', 'Rajeev Garg', 'Nurse', 'Staff Nurse', '1995-06-15', 9584751246, 'Delhi', 'DE004'),
       ('S0002', 'Shweta Garg', 'Lab Technician', 'Technician', '1997-10-18', 7501264032, 'Delhi', 'DE006'),
       ('S0003', 'Pankaj Agarwal', 'Nurse', 'Head Nurse', '1999-06-23', 7541203698, 'Ghaziabad', 'DE005'),
       ('S0004', 'Jethalal Gada', 'Attender', 'Junior Attender', '1989-10-23', 9548721032, 'Delhi', 'DE001'),
       ('S0005', 'Rahul Goel', 'Helper', 'Helper', '1991-04-25', 7012305874, 'Gurugram', 'DE003'),
       ('S0006', 'Rushak Savant', 'Lab Technician', 'Senior Technician', '1992-08-15', 7012540980, 'Mumbai', 'DE002');

INSERT INTO Test_Types (TT_ID, Description, Low_Value, High_Value, Test_Method, Technician)
VALUES ('TT0003', 'Blood Test', 24, 56, 'Blood Collection', 'S0004'),
       ('TT0001', 'Urine Test', 156, 199, 'Urine sample Collection', 'S0002'),
       ('TT0002', 'Heart Test', 56, 110, NULL, 'S0001'),
       ('TT0006', 'MRI', 98, 125, NULL, 'S0006'),
       ('TT0004', 'Diabetic Test', 30, 68, 'Blood sample Collection', 'S0005'),
       ('TT0005', 'Stool Test', 43, 54, 'Stool sample Collection', 'S0003');


INSERT INTO Test_Results (Test_ID, TT_ID, Result)
VALUES ('TE0006', 'TT0001', 'Positive'),
       ('TE0005', 'TT0003', 'Negative'),
       ('TE0002', 'TT0006', 'Negative'),
       ('TE0001', 'TT0002', 'Positive'),
       ('TE0004', 'TT0004', 'Positive'),
       ('TE0003', 'TT0005', 'Negative');

INSERT INTO Appointment (App_ID, Pat_ID, Doc_ID, Nurse_ID, Consult_Room_No, Date, Time)
VALUES ('AP0001', 'P0003', 'D0002', 'S0003', 134, '2020-08-02', '8:13:45'),
       ('AP0002', 'P0006', 'D0006', 'S0005', 345, '2020-07-01', '9:19:45'),
       ('AP0003', 'P0002', 'D0001', 'S0006', 045, '2020-07-15', '10:21:47'),
       ('AP0004', 'P0001', 'D0004', 'S0004', 213, '2020-07-25', '6:35:45'),
       ('AP0005', 'P0005', 'D0003', 'S0002', 111, '2020-01-11', '5:47:15'),
       ('AP0006', 'P0004', 'D0005', 'S0001', 456, '2020-07-21', '3:39:45');

INSERT INTO Prescription (Pres_ID, App_ID, Date, Time, Diagnosis_Detail)
VALUES ('PR0005', 'AP0003', '2020-02-23', '21:32:35', 'High Sugar Level, Low BP'),
       ('PR0002', 'AP0006', '2019-09-02', '23:15:35', 'Low Sugar Level, Low BP'),
       ('PR0006', 'AP0004', '2019-05-13', '2:39:35', 'Coronavirus'),
       ('PR0001', 'AP0002', '2020-01-25', '1:03:35', 'Common Cold'),
       ('PR0004', 'AP0001', '2020-05-23', '15:02:35', 'Typhoid'),
       ('PR0003', 'AP0005', '2020-06-20', '18:30:35', 'Chicken Pox');

INSERT INTO In_Patient_Prescription (Pat_ID, Pres_ID)
VALUES ('P0004', 'PR0001'),
       ('P0003', 'PR0002'),
       ('P0002', 'PR0005'),
       ('P0006', 'PR0006'),
       ('P0005', 'PR0004'),
       ('P0001', 'PR0003');

INSERT INTO Prescribed_Medicines (Pres_ID, Medicine_Name, Dosage, Brand)
VALUES ('PR0003', 'Glycomet', 'Twice a day', 'Cipla'),
       ('PR0001', 'Lantus', 'Thrice a day', 'Cipla'),
       ('PR0006', 'Combiflam', 'Once a day', 'Mankind'),
       ('PR0005', 'Glycomet', 'Every four hours', 'Cipla'),
       ('PR0002', 'Biotin', 'Twice a day', 'Mankind'),
       ('PR0004', 'Capsules', 'Once a week', 'Cipla');
#******************************************************************************************#

# Q1 Write a PL/SQL program to implement a simple calculator.


DELIMITER //

CREATE PROCEDURE Calculate(IN First_Variable INT(3),
                           IN Second_Variable INT(3),
                           IN Operation_Type CHAR(1))
BEGIN

    DECLARE Result VARCHAR(255);

    IF Operation_Type = '+'
    THEN
        SET Result = First_Variable + Second_Variable;
    ELSEIF Operation_Type = '-'
    THEN
        SET Result = First_Variable - Second_Variable;
    ELSEIF Operation_Type = '*'
    THEN
        SET Result = First_Variable * Second_Variable;
    ELSEIF Operation_Type = '/'
    THEN
        IF Second_Variable = 0
        THEN
            SET Result = 'Cannot Divide by Zero';
        ELSE
            SET Result = First_Variable / Second_Variable;
        END IF;
    ELSE
        SET Result = 'Operation is not valid';
    END IF;

    SELECT Result;

END //

DELIMITER ;

CALL Calculate(12, 13, '+');
CALL Calculate(12, 13, '/');
CALL Calculate(13, 0, '/');
CALL Calculate(13, 0, 'p');


# Q2 Write a PL/SQL program to practice reading the record from a table into local variables using different data types and %TYPE and display the same using locally declared variables.

# CODE 1

DELIMITER //

CREATE PROCEDURE Store_Records(
    OUT Output_Variable DOUBLE(10, 2)
)

BEGIN

    SELECT AVG(Bill_Amount)
    INTO Output_Variable
    FROM Hospital_Bill;

    SELECT Output_Variable;
END //

DELIMITER ;

# CODE 2

DELIMITER //

CREATE PROCEDURE Store_Records1(
    OUT Output_Variable VARCHAR(255)
)

BEGIN

    SELECT Dept_Name
    INTO Output_Variable
    FROM Department
    WHERE Dept_No = 'DE001';

    SELECT Output_Variable;
END //

DELIMITER ;

CALL Store_Records(@Average_Bill_Amount);
CALL Store_Records1(@Department_Names);

# Q3 Write a PL/SQL program to find the number of doctors in a given department with a given qualification (read values for department and qualification from user during runtime). If number is more than the number of doctors in that department with other qualifications then display ‘Well qualified’ else ‘Qualified’

DELIMITER //

CREATE PROCEDURE Enhanced_Doc_Count(IN Department_Name VARCHAR(255),
                                    IN Qual VARCHAR(255))

BEGIN
    DECLARE a INT;
    DECLARE b INT;
    SELECT Dept_Name, Qualification, COUNT(Doc_Id) AS Number_Of_Doctors
    INTO @Name, @Qualification, a
    FROM Department
             CROSS JOIN Doctor
                        ON Department.Dept_No = Doctor.Dept_No
    WHERE Dept_Name = Department_Name
      AND Qualification = Qual
    GROUP BY Dept_Name, Qualification;

    SELECT Dept_Name, Qualification, COUNT(Doc_Id) AS Number_Of_Doctors
    INTO @Name, @Qualification, b
    FROM Department
             CROSS JOIN Doctor
                        ON Department.Dept_No = Doctor.Dept_No
    WHERE Dept_Name = Department_Name
      AND Qualification != Qual
    GROUP BY Dept_Name, Qualification;

    IF a > b THEN
        SELECT "WELL QUALIFIED";
    ELSE
        SELECT "QUALIFIED";
    END IF;


END //

DELIMITER ;

CALL Enhanced_Doc_Count('Diabetes', 'MBBS');


# Q4 Write a PL/SQL program to insert records into any of the tables in your database.

DELIMITER //

CREATE PROCEDURE Insert_Records(IN Pat_ID CHAR(5),
                                IN Pat_Name VARCHAR(20),
                                IN DOB DATE,
                                IN Gender CHAR(1),
                                IN Contact BIGINT(10),
                                IN Address VARCHAR(255))

BEGIN

    INSERT INTO Patient()
    VALUES (Pat_Id, Pat_Name, DOB, Gender, Contact, Address);

END //

DELIMITER ;

SELECT *
FROM Patient;

CALL Insert_Records('P2204', 'Huma Singh', '1960-10-31', 'F', 6089564589,
                    'House Number - 05, Block - 100 Mayapuri - New Delhi');

SELECT *
FROM Patient;

# Q5 Create a function to find the factorial of a given number

DELIMITER //

CREATE PROCEDURE Factorial(
    IN num INT(3)
)

BEGIN
    IF num < 0
    THEN
        SET @fact = 'Factorial of a negative number is not defined';
    ELSEIF num = 0
    THEN
        SET @fact = 1;
    ELSE
        SET @iterator = 1;
        SET @fact = 1;

        WHILE (@iterator < num + 1)
            DO
                SET @fact = @fact * @iterator;
                SET @iterator = @iterator + 1;
            END WHILE;
    END IF;

    SELECT @fact AS Result;

END //

DELIMITER ;

CALL Factorial(5);
CALL Factorial(-10);


# Q6 Create a function DOC_COUNT to find the number of doctors in the given department. Use the department name as the input parameter for the function.

DELIMITER //

CREATE PROCEDURE Doc_Count(
    IN Department_Name VARCHAR(255)
)

BEGIN

    SELECT Dept_Name, COUNT(Doc_ID) AS Number_Of_Doctors
    FROM Department AS de
             CROSS JOIN Doctor AS doc
                        ON de.Dept_No = doc.Dept_No
    WHERE Dept_Name = Department_Name
    GROUP BY Dept_Name;

END //

DELIMITER ;

CALL Doc_Count('Diabetes');


# CURSORS

# Q1 Write a CURSOR to give 5% additional discount to all senior citizen patients

DELIMITER //

CREATE PROCEDURE AdditionalDiscount()
BEGIN
    DECLARE Id CHAR(5);
    DECLARE Name VARCHAR(15);
    DECLARE DOB DATE;
    DECLARE Gender CHAR(1);
    DECLARE contact VARCHAR(20);
    DECLARE Address TEXT;
    DECLARE age DECIMAL(5, 2);
    DECLARE dis FLOAT DEFAULT 0;
    DECLARE Done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT * FROM Patient;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = 1;
    OPEN cur;

    loop1:
    LOOP
        FETCH cur INTO Id, Name, DOB, Gender, Contact, Address;
        IF Done = 1 THEN
            LEAVE loop1;
        END IF;
        SET age = TIMESTAMPDIFF(MONTH, DOB, SYSDATE()) / 12;
        IF (age >= 60) THEN
            SET @age = age;
            SELECT Discount INTO dis FROM Hospital_Bill WHERE Pat_ID = Id;
            SET @before_discount = dis;
            UPDATE Hospital_Bill SET Discount=Discount + 5 WHERE Pat_ID = Id;
            SELECT Discount into dis FROM Hospital_Bill WHERE Pat_ID = Id;
            SET @after_discount = dis;

            SELECT @age, @before_discount, @after_discount AS Output;
        END IF;
    END LOOP;
    SELECT @age, @before_discount, @after_discount AS Output;
    CLOSE cur;
END //
DELIMITER ;

CALL AdditionalDiscount();

# Q2 Write a CURSOR to change the department number from 1 as 5 for all doctors with a qualification ‘MD’.

DELIMITER //

CREATE PROCEDURE ChangeDept()
BEGIN
    DECLARE Id CHAR(5);
    DECLARE Name VARCHAR(15);
    DECLARE Gender CHAR(1);
    DECLARE DOB DATE;
    DECLARE Specialist VARCHAR(15);
    DECLARE Qualification VARCHAR(15);
    DECLARE Contact VARCHAR(20);
    DECLARE Address TEXT;
    DECLARE Dept_no CHAR(5);

    DECLARE Done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT * FROM Doctor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = 1;
    OPEN cur;

    loop1:
    LOOP
        FETCH cur INTO Id, Name, Gender, DOB, Specialist, Qualification, Contact, Address, Dept_No;
        IF Done = 1 THEN
            LEAVE loop1;
        END IF;

        IF Qualification = 'MD' AND Dept_No = 'DE001' THEN
            SET @doc_id = Id;
            SELECT Dept_No INTO @Dept FROM Doctor WHERE Doc_ID = Id;
            SET @prev_dept_no = @Dept;
            UPDATE Doctor SET Dept_No='DE005' WHERE Doc_ID = Id;
            SELECT Dept_No INTO @Dept FROM Doctor WHERE Doc_ID = Id;
            SET @new_dept_no = @Dept;
        END IF;
    END LOOP;
    SELECT @doc_id, @prev_dept_no, @new_dept_no AS Output;
    CLOSE cur;
END //

DELIMITER ;

SELECT *
FROM Doctor
WHERE Qualification = 'MD'
  AND Dept_No = 'DE001';

CALL ChangeDept();

SELECT *
FROM Doctor
WHERE Qualification = 'MD'
  AND Dept_No = 'DE005';


# Functions And Procedures

# Q1 Write a PL/SQL stored function COUNT_DOC to count the number of doctors who have treated at least 100 patients if given a doctor id as input parameter.

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //

CREATE FUNCTION Count_Doc(Id CHAR(5))
    RETURNS INT
BEGIN
    DECLARE cnt INT;
    SELECT COUNT(Pat_ID) into cnt FROM Appointment WHERE Doc_ID = Id;
    RETURN cnt;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DoctorCount()
BEGIN
    DECLARE Id CHAR(5);
    DECLARE Name VARCHAR(15);
    DECLARE Gender CHAR(1);
    DECLARE DOB DATE;
    DECLARE Specialist VARCHAR(15);
    DECLARE Qualification VARCHAR(15);
    DECLARE Contact VARCHAR(20);
    DECLARE Address TEXT;
    DECLARE Dept_no CHAR(5);
    DECLARE cnt INT;
    DECLARE total INT DEFAULT 0;

    DECLARE Done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT * FROM Doctor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = 1;
    OPEN cur;

    loop1:
    LOOP
        FETCH cur INTO Id, Name, Gender, DOB, Specialist, Qualification, Contact, Address, Dept_No;
        IF Done = 1 THEN
            LEAVE loop1;
        END IF;

        SET cnt = Count_Doc(Id);

        IF (cnt >= 100) THEN
            SET total = total + 1;
        END IF;
    END LOOP;
    SELECT total as Count;
    CLOSE cur;
END //

DELIMITER ;

CALL DoctorCount();

# Q2 Write a PL/SQL stored procedure to adjust the payment type of hospital bills to CASH if the patient id and amount details given as input.

DELIMITER //

CREATE PROCEDURE Payment(p_id CHAR(5), amt FLOAT)
BEGIN
    DECLARE p_type VARCHAR(15);
    SELECT Payment_Type INTO p_type FROM Hospital_Bill WHERE Pat_ID = p_id;
    SET @bill_amount = amt;
    SET @old_payment_type = p_type;
    UPDATE Hospital_Bill SET Payment_Type='Cash' WHERE Pat_ID = p_id AND Bill_Amount = amt;
    SELECT Payment_Type INTO p_type FROM Hospital_Bill WHERE Pat_ID = p_id AND Bill_Amount = amt;
    SELECT p_type, @bill_amount, @old_payment_type AS Details;
END //

DELIMITER ;

SELECT *
FROM Hospital_Bill
WHERE Pat_ID = 'P0005'
  AND Bill_Amount = 85890;

CALL Payment('P0005', 85890);

SELECT *
FROM Hospital_Bill
WHERE Pat_ID = 'P0005'
  AND Bill_Amount = 85890;

# Triggers

# Q1 Add an attribute with patients table to store the age of the patients. Write a Trigger to find and fill the age of a patient whenever a patient record is inserted into patients table.

ALTER TABLE Patient
    ADD Age INT;

DELIMITER //

CREATE TRIGGER patient_age
    BEFORE INSERT
    ON Patient
    FOR EACH ROW
BEGIN
    DECLARE age1 INT;
    SET NEW.Age = TIMESTAMPDIFF(MONTH, NEW.DOB, SYSDATE()) / 12;

END //

DELIMITER ;

SELECT *
FROM Patient;

INSERT INTO Patient (Pat_ID, Pat_Name, DOB, Gender, Contact, Address, Age)
VALUES ('P0007', 'Raman Bhatia', '1976-12-10', 'M', '8541245896', 'Mirzapur', 0);

SELECT *
FROM Patient;

# Q2 Create a table EMP_SALARY with attributes ID, Basic, DA, HRA, Deduction, Net_Salary. Here, ID refers the Staff_ID of staff table.

CREATE TABLE EMP_SALARY
(
    id         VARCHAR(5) PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES Staff (staff_id),
    basic      INT           NOT NULL,
    DA         INT           NOT NULL,
    HRA        INT           NOT NULL,
    deduction  DECIMAL(5, 2) NOT NULL,
    net_salary INT           NOT NULL
);

CREATE TRIGGER cal_net_salary
    BEFORE INSERT
    ON EMP_SALARY
    FOR EACH ROW
BEGIN
    SET NEW.net_salary = (NEW.basic + NEW.DA + NEW.HRA) - (NEW.deduction * NEW.basic / 100);
END;

CREATE TRIGGER emp_sal_detail
    AFTER INSERT
    ON Staff
    FOR EACH ROW
BEGIN
    CASE NEW.Designation
        WHEN 'Staff Nurse' THEN INSERT INTO EMP_SALARY VALUES (NEW.Staff_ID, 6000, 2000, 2000, 2, 0);
        WHEN 'Head Nurse' THEN INSERT INTO EMP_SALARY VALUES (NEW.Staff_ID, 8000, 2500, 3000, 2, 0);
        WHEN 'Technician' THEN INSERT INTO EMP_SALARY VALUES (NEW.Staff_ID, 6000, 2000, 2000, 2, 0);
        WHEN 'Senior Technician' THEN INSERT INTO EMP_SALARY VALUES (NEW.Staff_ID, 9000, 2500, 3500, 2.5, 0);
        WHEN 'Junior Attender' THEN INSERT INTO EMP_SALARY VALUES (NEW.Staff_ID, 5000, 1500, 2000, 2, 0);
        WHEN 'Senior Attender' THEN INSERT INTO EMP_SALARY VALUES (NEW.Staff_ID, 6500, 2000, 2000, 2, 0);
        END CASE;
END;

INSERT INTO Staff
VALUES ('S0007', 'Elijah', 'Nurse', 'Staff Nurse', '1980-12-30', '9854124562', 'Flat 3A ELM', 'DE001');

SELECT *
FROM EMP_SALARY;




