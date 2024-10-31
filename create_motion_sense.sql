/* Create Tables */

/* Trainer */

CREATE TABLE Trainer(
    TrnID SERIAL,
    TrnFirstName VARCHAR(35) NOT NULL,
    TrnLastName VARCHAR(35) NOT NULL,
    TrnEmail VARCHAR(254),
    TrnPhone VARCHAR(20)
);

ALTER TABLE Trainer
    ADD CONSTRAINT TrnPK
    PRIMARY KEY (TrnID);

/* Doctor */

CREATE TABLE Doctor(
    DocID SERIAL,
    DocFirstName VARCHAR(35) NOT NULL,
    DocLastName VARCHAR(35) NOT NULL,
    DocEmail VARCHAR(254),
    DocPhone VARCHAR(20)
);

ALTER TABLE Doctor
    ADD CONSTRAINT DocPK
    PRIMARY KEY (DocID);

/* Athlete */
    
CREATE TABLE Athlete(
    AthID SERIAL,
    TrnID INT NOT NULL,
    DocID INT,
    AthFirstName VARCHAR(35) NOT NULL,
    AthLastName VARCHAR(35) NOT NULL,
    AthDateOfBirth DATE,
    AthEmail VARCHAR(254),
    AthPhone VARCHAR(20),
    AthActive BOOLEAN NOT NULL DEFAULT TRUE
);

ALTER TABLE Athlete
    ADD CONSTRAINT AthPK
    PRIMARY KEY (AthID);

ALTER TABLE Athlete
    ADD CONSTRAINT AthTrnFK
    FOREIGN KEY (TrnID)
    REFERENCES Trainer(TrnID);

ALTER TABLE Athlete
    ADD CONSTRAINT AthDocFK
    FOREIGN KEY (DocID)
    REFERENCES Doctor(DocID);

/* Exercise */

CREATE TYPE ExerciseType AS ENUM ('Cardio', 'Strength');

CREATE TABLE Exercise(
    ExrID SERIAL,
    ExrName VARCHAR(100) NOT NULL,
    ExrType ExerciseType NOT NULL
);

ALTER TABLE Exercise
    ADD CONSTRAINT ExrPK
    PRIMARY KEY (ExrID);

/* WorkoutPlan */

CREATE TABLE WorkoutPlan(
    WrkPlanID SERIAL,
    AthID INT NOT NULL,
    WrkPlanName VARCHAR(100) NOT NULL,
    WrkPlanStartDate DATE NOT NULL,
    WrkPlanEndDate DATE NOT NULL,
    WrkPlanSchedule VARCHAR(100)
);

ALTER TABLE WorkoutPlan
    ADD CONSTRAINT WrkPlanPK
    PRIMARY KEY (WrkPlanID);

ALTER TABLE WorkoutPlan
    ADD CONSTRAINT WrkPlanAthFK
    FOREIGN KEY (AthID)
    REFERENCES Athlete(AthID);

/* ExercisePlan */

CREATE TABLE ExercisePlan(
    ExrPlanID SERIAL,
    ExrID INT NOT NULL,
    WrkPlanID INT NOT NULL,
    ExrPlanNotes VARCHAR(100)
);

ALTER TABLE ExercisePlan
    ADD CONSTRAINT ExrPlanPK
    PRIMARY KEY (ExrPlanID);

ALTER TABLE ExercisePlan
    ADD CONSTRAINT ExrPlanExrFK
    FOREIGN KEY (ExrID)
    REFERENCES Exercise(ExrID);

ALTER TABLE ExercisePlan
    ADD CONSTRAINT ExrPlanWrkPlanFK
    FOREIGN KEY (WrkPlanID)
    REFERENCES WorkoutPlan(WrkPlanID);

/* CardioPlan */

CREATE TABLE CardioPlan(
    ExrPlanID INT NOT NULL,
    CdoPlanSets INT,
    CdoPlanDistance FLOAT,
    CdoPlanDuration FLOAT
);

ALTER TABLE CardioPlan
    ADD CONSTRAINT CdoPlanPK
    PRIMARY KEY (ExrPlanID);

ALTER TABLE CardioPlan
    ADD CONSTRAINT CdoPlanExrPlanFK
    FOREIGN KEY (ExrPlanID)
    REFERENCES ExercisePlan(ExrPlanID);

/* StrengthPlan */

CREATE TABLE StrengthPlan(
    ExrPlanID INT NOT NULL,
    StrPlanSets INT,
    StrPlanReps INT,
    StrPlanWeight FLOAT
);

ALTER TABLE StrengthPlan
    ADD CONSTRAINT StrPlanPK
    PRIMARY KEY (ExrPlanID);

ALTER TABLE StrengthPlan
    ADD CONSTRAINT StrPlanExrPlanFK
    FOREIGN KEY (ExrPlanID)
    REFERENCES ExercisePlan(ExrPlanID);

/* WorkoutLog */

CREATE TABLE WorkoutLog(
    WrkLogID SERIAL,
    WrkPlanID INT NOT NULL,
    WrkLogDate DATE NOT NULL
);

ALTER TABLE WorkoutLog
    ADD CONSTRAINT WrkLogPK
    PRIMARY KEY (WrkLogID);

ALTER TABLE WorkoutLog
    ADD CONSTRAINT WrkLogWrkPlanFK
    FOREIGN KEY (WrkPlanID)
    REFERENCES WorkoutPlan(WrkPlanID);

/* ExerciseLog */

CREATE TABLE ExerciseLog(
    ExrLogID SERIAL,
    ExrPlanID INT NOT NULL,
    WrkLogID INT NOT NULL,
    ExrLogNotes VARCHAR(100)
);

ALTER TABLE ExerciseLog
    ADD CONSTRAINT ExrLogPK
    PRIMARY KEY (ExrLogID);

ALTER TABLE ExerciseLog
    ADD CONSTRAINT ExrLogExrPlanFK
    FOREIGN KEY (ExrPlanID)
    REFERENCES ExercisePlan(ExrPlanID);

ALTER TABLE ExerciseLog
    ADD CONSTRAINT ExrLogWrkLogFK
    FOREIGN KEY (WrkLogID)
    REFERENCES WorkoutLog(WrkLogID);

/* CardioLog */

CREATE TABLE CardioLog(
    ExrLogID INT NOT NULL,
    CdoLogSets INT,
    CdoLogDistance FLOAT,
    CdoLogDuration FLOAT
);

ALTER TABLE CardioLog
    ADD CONSTRAINT CdoLogPK
    PRIMARY KEY (ExrLogID);

ALTER TABLE CardioLog
    ADD CONSTRAINT CdoLogExrLogFK
    FOREIGN KEY (ExrLogID)
    REFERENCES ExerciseLog(ExrLogID);

/* StrengthLog */

CREATE TABLE StrengthLog(
    ExrLogID INT NOT NULL,
    StrLogSets INT,
    StrLogReps INT,
    StrLogWeight FLOAT
);

ALTER TABLE StrengthLog
    ADD CONSTRAINT StrLogPK
    PRIMARY KEY (ExrLogID);

ALTER TABLE StrengthLog
    ADD CONSTRAINT StrLogExrLogFK
    FOREIGN KEY (ExrLogID)
    REFERENCES ExerciseLog(ExrLogID);



/* Populate Tables */

/* Trainer */

INSERT INTO Trainer (TrnID, TrnFirstName, TrnLastName, TrnEmail, TrnPhone)
VALUES
(1,'Timothy','Thomas', 'tthomas@example.com', '(541) 555-0000'),
(2,'Tracy','Taylor', 'ttaylor@example.com', '(541) 555-0001'),
(3,'Tanner','Thompson', 'tthompson@example.com', '(541) 555-0002'),
(4,'Tessa','Torres', 'ttorres@example.com', '(541) 555-0003'),
(5,'Terrance','Townsend', 'ttownsend@example.com', '(541) 555-0004');

/* Doctor */

INSERT INTO Doctor (DocID, DocFirstName, DocLastName, DocEmail, DocPhone)
VALUES
(1,'Deborah','Davis', 'ddavis@example.com', '(541) 555-0020'),
(2,'Daniel','Diaz', 'ddiaz@example.com', '(541) 555-0021'),
(3,'Diana','Delgado', 'ddelgado@example.com', '(541) 555-0022'),
(4,'DavID','dixon', 'ddixon@example.com', '(541) 555-0023'),
(5,'Darcy','Dean', 'ddean@example.com', '(541) 555-0024');

/* Athlete */

INSERT INTO Athlete (AthID, TrnID, DocID, AthFirstName, AthLastName, AthDateOfBirth, AthEmail, AthPhone) 
VALUES
(1, 1, 1, 'Andrea', 'Adams', '2000-01-01', 'aadams@example.com', '(541) 555-0010'),
(2, 2, 2, 'Aaron', 'Anderson', '2000-01-02', 'aanderson@example.com', '(541) 555-0011'),
(3, 3, null, 'Amber', 'Alexander', '2000-01-03', 'aalexander@example.com', '(541) 555-0012'),
(4, 4, null, 'Abraham', 'Allen', '2000-01-04', 'aallen@example.com', '(541) 555-0013'),
(5, 5, 5, 'Amelia', 'Abbott', '2000-01-05', 'aabbott@example.com', '(541) 555-0014');

/* Exercise */

INSERT INTO Exercise (ExrID, ExrName, ExrType)
VALUES
(1, 'Running', 'Cardio'),
(2, 'Swimming', 'Cardio'),
(3, 'Rowing', 'Cardio'),
(4, 'Biking', 'Cardio'),
(5, 'Jump Rope', 'Cardio'),
(6, 'Squat', 'Strength'),
(7, 'Deadlift', 'Strength'),
(8, 'Bench', 'Strength'),
(9, 'Back Row', 'Strength'),
(10, 'Pullup', 'Strength'),
(11, 'Pushup', 'Strength'),
(12, 'Situp', 'Strength');

/* WorkoutPlan */

INSERT INTO WorkoutPlan (WrkPlanID, AthID, WrkPlanName, WrkPlanStartDate, WrkPlanEndDate, WrkPlanSchedule)
VALUES
(1, 1, 'Run', '2023-01-01', '2023-01-15', 'Three times a week'),
(2, 2, 'Bodyweight Workout', '2023-02-02', '2023-02-22', 'Every Monday and Thursday'),
(3, 1, 'Lower Body Power', '2023-01-15', '2023-02-01', 'Three times a week'),
(4, 3, 'Full Body Workout', '2023-04-01', '2023-04-08', 'Two times a week'),
(5, 2, 'Swim', '2023-02-23', '2023-03-01', 'Four times a week');

/* ExercisePlan */

INSERT INTO ExercisePlan (ExrPlanID, ExrID, WrkPlanID, ExrPlanNotes)
VALUES
(1, 1, 1, ''),
(2, 4, 2, 'Warmup'),
(3, 10, 2, ''),
(4, 11, 2, ''),
(5, 12, 2, ''),
(6, 5, 3, '3 sets of 30 seconds'),
(7, 6, 3, 'Maximise power, move weight quickly'),
(8, 7, 3, 'Maximise power, move weight quickly'),
(10, 6, 4, 'First set should be warmup, weight is target for last set'),
(11, 8, 4, 'First set should be warmup, weight is target for last set'),
(12, 9, 4, 'First set should be warmup, weight is target for last set'),
(13, 1, 4, ''),
(14, 2, 5, '');

/* CardioPlan */

INSERT INTO CardioPlan (ExrPlanID, CdoPlanSets, CdoPlanDistance, CdoPlanDuration)
VALUES
(1, 1, 2.0, NULL),
(2, 1, NULL, 5.0),
(6, 3, NULL, 0.5),
(13, 1, NULL, 10.0),
(14, 5, 100.0, NULL);

/* StrengthPlan */

INSERT INTO StrengthPlan (ExrPlanID, StrPlanSets, StrPlanReps, StrPlanWeight)
VALUES
(3, 3, 8, NULL),
(4, 3, 15, NULL),
(5, 3, 20, NULL),
(7, 4, 4, 145),
(8, 4, 4, 245),
(10, 3, 6, 200),
(11, 3, 6, 150),
(12, 3, 6, 120);

/* WorkoutLog */

INSERT INTO WorkoutLog (WrkLogID, WrkPlanID, WrkLogDate) 
VALUES
(1, 1, '2023-01-01'),
(2, 1, '2023-01-04'),
(3, 1, '2023-01-07'),
(4, 2, '2023-02-02'),
(5, 2, '2023-02-06'),
(7, 3, '2023-01-15'),
(8, 3, '2023-01-019'),
(9, 4, '2023-04-08');

/* ExerciseLog */

INSERT INTO ExerciseLog (ExrLogID, ExrPlanID, WrkLogID, ExrLogNotes) 
VALUES
(1, 1, 1, null),
(2, 1, 2, null),
(3, 1, 3, 'tired today'),
(4, 2, 4, null),
(5, 3, 4, 'could not quite get 8 pullups'),
(6, 4, 4, 'could not quite get 15 pushups'),
(7, 5, 4, null),
(8, 2, 5, null),
(9, 3, 5, null),
(10, 4, 5, null),
(11, 5, 5, null),
(12, 6, 7, '30 seconds was easy'),
(13, 7, 7, null),
(14, 8, 7, null),
(15, 6, 8, '30 seconds was easy'),
(16, 7, 8, null),
(17, 8, 8, null),
(18, 10, 9, 'feeling great today, dID extra weight'),
(19, 11, 9, 'feeling great today, went up in weight'),
(20, 12, 9, 'feeling great today, went up in weight'),
(21, 13, 9, null);

/* CardioLog */

INSERT INTO CardioLog (ExrLogID, CdoLogSets, CdoLogDistance, CdoLogDuration) 
VALUES
(1, 1, 2.0, 15.0),
(2, 1, 2.0, 14.0),
(3, 1, 2.0, 15.5),
(4, 1, null, 5.0),
(8, 1, null, 5.0),
(12, 3, null, null),
(15, 3, null, null),
(21, 1, 0.9, 10);

/* StrengthLog */

INSERT INTO StrengthLog (ExrLogID, StrLogSets, StrLogReps, StrLogWeight) 
VALUES
(5, 3, 7, null),
(6, 3, 13, null),
(7, 3, 20, null),
(9, 3, 8, null),
(10, 3, 15, null),
(11, 3, 20, null),
(13, 4, 4, 145),
(14, 4, 4, 245),
(16, 4, 4, 155),
(17, 4, 4, 245),
(18, 3, 6, 215),
(19, 3, 6, 165),
(20, 3, 6, 135);
