use f23_motionSense;



/* Create Tables */

/* trainer */

CREATE TABLE trainer(
    trnID INT(4) NOT NULL,
    trnFirstName VARCHAR(35) NOT NULL,
    trnLastName VARCHAR(35) NOT NULL,
    trnEmail VARCHAR(254),
    trnPhone VARCHAR(20)
);

ALTER TABLE trainer
    ADD CONSTRAINT trnPK
    PRIMARY KEY (trnID);

ALTER TABLE trainer
    MODIFY COLUMN trnID INT(4) NOT NULL AUTO_INCREMENT;

/* doctor */

CREATE TABLE doctor(
    docID INT(4) NOT NULL,
    docFirstName VARCHAR(35) NOT NULL,
    docLastName VARCHAR(35) NOT NULL,
    docEmail VARCHAR(254),
    docPhone VARCHAR(20)
);

ALTER TABLE doctor
    ADD CONSTRAINT docPK
    PRIMARY KEY (docID);

ALTER TABLE doctor
    MODIFY COLUMN docID INT(4) NOT NULL AUTO_INCREMENT;

/* athlete */
    
CREATE TABLE athlete(
    athID INT(4) NOT NULL,
    trnID INT(4) NOT NULL,
    docID INT(4),
    athFirstName VARCHAR(35) NOT NULL,
    athLastName VARCHAR(35) NOT NULL,
    athDateOfBirth DATE,
    athEmail VARCHAR(254),
    athPhone VARCHAR(20),
    athActive BOOLEAN NOT NULL DEFAULT TRUE
);

ALTER TABLE athlete
    ADD CONSTRAINT athPK
    PRIMARY KEY (athID);

ALTER TABLE athlete
    MODIFY COLUMN athID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE athlete
    ADD CONSTRAINT athTrnFK
    FOREIGN KEY (trnID)
    REFERENCES trainer(trnID);

ALTER TABLE athlete
    ADD CONSTRAINT athDocFK
    FOREIGN KEY (docID)
    REFERENCES doctor(docID);

/* exercise */

CREATE TABLE exercise(
    exrID INT(4) NOT NULL,
    exrName VARCHAR(100) NOT NULL,
    exrType ENUM('Cardio', 'Strength') NOT NULL
);

ALTER TABLE exercise
    ADD CONSTRAINT exrPK
    PRIMARY KEY (exrID);

ALTER TABLE exercise
    MODIFY COLUMN exrID INT(4) NOT NULL AUTO_INCREMENT;

/* workoutPlan */

CREATE TABLE workoutPlan(
    wrkPlanID INT(4) NOT NULL,
    athID INT(4) NOT NULL,
    wrkPlanName VARCHAR(100) NOT NULL,
    wrkPlanStartDate DATE NOT NULL,
    wrkPlanEndDate DATE NOT NULL,
    wrkPlanSchedule VARCHAR(100)
);

ALTER TABLE workoutPlan
    ADD CONSTRAINT wrkPlanPK
    PRIMARY KEY (wrkPlanID);

ALTER TABLE workoutPlan
    MODIFY COLUMN wrkPlanID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE workoutPlan
    ADD CONSTRAINT wrkPlanAthFK
    FOREIGN KEY (athID)
    REFERENCES athlete(athID);

/* exercisePlan */

CREATE TABLE exercisePlan(
    exrPlanID INT(4) NOT NULL,
    exrID INT(4) NOT NULL,
    wrkPlanID INT(4) NOT NULL,
    exrPlanNotes VARCHAR(100)
);

ALTER TABLE exercisePlan
    ADD CONSTRAINT exrPlanPK
    PRIMARY KEY (exrPlanID);

ALTER TABLE exercisePlan
    MODIFY COLUMN exrPlanID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE exercisePlan
    ADD CONSTRAINT exrPlanExrFK
    FOREIGN KEY (exrID)
    REFERENCES exercise(exrID);

ALTER TABLE exercisePlan
    ADD CONSTRAINT exrPlanWrkPlanFK
    FOREIGN KEY (wrkPlanID)
    REFERENCES workoutPlan(wrkPlanID);

/* cardioPlan */

CREATE TABLE cardioPlan(
    exrPlanID INT(4) NOT NULL,
    cdoPlanSets INT(4),
    cdoPlanDistance FLOAT,
    cdoPlanDuration FLOAT
);

ALTER TABLE cardioPlan
    ADD CONSTRAINT cdoPlanPK
    PRIMARY KEY (exrPlanID);

ALTER TABLE cardioPlan
    ADD CONSTRAINT cdoPlanExrPlanFK
    FOREIGN KEY (exrPlanID)
    REFERENCES exercisePlan(exrPlanID);

/* strengthPlan */

CREATE TABLE strengthPlan(
    exrPlanID INT(4) NOT NULL,
    strPlanSets INT(4),
    strPlanReps INT(4),
    strPlanWeight FLOAT
);

ALTER TABLE strengthPlan
    ADD CONSTRAINT strPlanPK
    PRIMARY KEY (exrPlanID);

ALTER TABLE strengthPlan
    ADD CONSTRAINT strPlanExrPlanFK
    FOREIGN KEY (exrPlanID)
    REFERENCES exercisePlan(exrPlanID);

/* workoutLog */

CREATE TABLE workoutLog(
    wrkLogID INT(4) NOT NULL,
    wrkPlanID INT(4) NOT NULL,
    wrkLogDate DATE NOT NULL
);

ALTER TABLE workoutLog
    ADD CONSTRAINT wrkLogPK
    PRIMARY KEY (wrkLogID);

ALTER TABLE workoutLog
    MODIFY COLUMN wrkLogID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE workoutLog
    ADD CONSTRAINT wrkLogWrkPlanFK
    FOREIGN KEY (wrkPlanID)
    REFERENCES workoutPlan(wrkPlanID);

/* exerciseLog */

CREATE TABLE exerciseLog(
    exrLogID INT(4) NOT NULL,
    exrPlanID INT(4) NOT NULL,
    wrkLogID INT(4) NOT NULL,
    exrLogNotes VARCHAR(100)
);

ALTER TABLE exerciseLog
    ADD CONSTRAINT exrLogPK
    PRIMARY KEY (exrLogID);

ALTER TABLE exerciseLog
    MODIFY COLUMN exrLogID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE exerciseLog
    ADD CONSTRAINT exrLogExrPlanFK
    FOREIGN KEY (exrPlanID)
    REFERENCES exercisePlan(exrPlanID);

ALTER TABLE exerciseLog
    ADD CONSTRAINT exrLogWrkLogFK
    FOREIGN KEY (wrkLogID)
    REFERENCES workoutLog(wrkLogID);

/* cardioLog */

CREATE TABLE cardioLog(
    exrLogID INT(4) NOT NULL,
    cdoLogSets INT(4),
    cdoLogDistance FLOAT,
    cdoLogDuration FLOAT
);

ALTER TABLE cardioLog
    ADD CONSTRAINT cdoLogPK
    PRIMARY KEY (exrLogID);

ALTER TABLE cardioLog
    ADD CONSTRAINT cdoLogExrLogFK
    FOREIGN KEY (exrLogID)
    REFERENCES exerciseLog(exrLogID);

/* strengthLog */

CREATE TABLE strengthLog(
    exrLogID INT(4) NOT NULL,
    strLogSets INT(4),
    strLogReps INT(4),
    strLogWeight FLOAT
);

ALTER TABLE strengthLog
    ADD CONSTRAINT strLogPK
    PRIMARY KEY (exrLogID);

ALTER TABLE strengthLog
    ADD CONSTRAINT strLogExrLogFK
    FOREIGN KEY (exrLogID)
    REFERENCES exerciseLog(exrLogID);



/* Populate Tables */

/* trainer */

INSERT INTO trainer (trnID, trnFirstName, trnLastName, trnEmail, trnPhone)
VALUES
(1,'Timothy','Thomas', 'tthomas@example.com', '(541) 555-0000'),
(2,'Tracy','Taylor', 'ttaylor@example.com', '(541) 555-0001'),
(3,'Tanner','Thompson', 'tthompson@example.com', '(541) 555-0002'),
(4,'Tessa','Torres', 'ttorres@example.com', '(541) 555-0003'),
(5,'Terrance','Townsend', 'ttownsend@example.com', '(541) 555-0004');

/* doctor */

INSERT INTO doctor (docID, docFirstName, docLastName, docEmail, docPhone)
VALUES
(1,'Deborah','Davis', 'ddavis@example.com', '(541) 555-0020'),
(2,'Daniel','Diaz', 'ddiaz@example.com', '(541) 555-0021'),
(3,'Diana','Delgado', 'ddelgado@example.com', '(541) 555-0022'),
(4,'David','dixon', 'ddixon@example.com', '(541) 555-0023'),
(5,'Darcy','Dean', 'ddean@example.com', '(541) 555-0024');

/* athlete */

INSERT INTO athlete (athID, trnID, docID, athFirstName, athLastName, athDateOfBirth, athEmail, athPhone) 
VALUES
(1, 1, 1, 'Andrea', 'Adams', '2000-01-01', 'aadams@example.com', '(541) 555-0010'),
(2, 2, 2, 'Aaron', 'Anderson', '2000-01-02', 'aanderson@example.com', '(541) 555-0011'),
(3, 3, null, 'Amber', 'Alexander', '2000-01-03', 'aalexander@example.com', '(541) 555-0012'),
(4, 4, null, 'Abraham', 'Allen', '2000-01-04', 'aallen@example.com', '(541) 555-0013'),
(5, 5, 5, 'Amelia', 'Abbott', '2000-01-05', 'aabbott@example.com', '(541) 555-0014');

/* exercise */

INSERT INTO exercise (exrID, exrName, exrType)
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

/* workoutPlan */

INSERT INTO workoutPlan (wrkPlanID, athID, wrkPlanName, wrkPlanStartDate, wrkPlanEndDate, wrkPlanSchedule)
VALUES
(1, 1, 'Run', '2023-01-01', '2023-01-15', 'Three times a week'),
(2, 2, 'Bodyweight Workout', '2023-02-02', '2023-02-22', 'Every Monday and Thursday'),
(3, 1, 'Lower Body Power', '2023-01-15', '2023-02-01', 'Three times a week'),
(4, 3, 'Full Body Workout', '2023-04-01', '2023-04-08', 'Two times a week'),
(5, 2, 'Swim', '2023-02-23', '2023-03-01', 'Four times a week');

/* exercisePlan */

INSERT INTO exercisePlan (exrPlanID, exrID, wrkPlanID, exrPlanNotes)
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

/* cardioPlan */

INSERT INTO cardioPlan (exrPlanID, cdoPlanSets, cdoPlanDistance, cdoPlanDuration)
VALUES
(1, 1, 2.0, NULL),
(2, 1, NULL, 5.0),
(6, 3, NULL, 0.5),
(13, 1, NULL, 10.0),
(14, 5, 100.0, NULL);

/* strengthPlan */

INSERT INTO strengthPlan (exrPlanID, strPlanSets, strPlanReps, strPlanWeight)
VALUES
(3, 3, 8, NULL),
(4, 3, 15, NULL),
(5, 3, 20, NULL),
(7, 4, 4, 145),
(8, 4, 4, 245),
(10, 3, 6, 200),
(11, 3, 6, 150),
(12, 3, 6, 120);

/* workoutLog */

INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES
(1, 1, '2023-01-01'),
(2, 1, '2023-01-04'),
(3, 1, '2023-01-07'),
(4, 2, '2023-02-02'),
(5, 2, '2023-02-06'),
(7, 3, '2023-01-15'),
(8, 3, '2023-01-019'),
(9, 4, '2023-04-08');

/* exerciseLog */

INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES
(1, 1, 1, null),
(2, 1, 2, null),
(3, 1, 3, 'tired today'),
(4, 2, 4, null),
(5, 3, 4, "couldn't quite get 8 pullups"),
(6, 4, 4, "couldn't quited get 15 pushups"),
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
(18, 10, 9, 'feeling great today, did extra weight'),
(19, 11, 9, 'feeling great today, went up in weight'),
(20, 12, 9, 'feeling great today, went up in weight'),
(21, 13, 9, null);

/* cardioLog */

INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES
(1, 1, 2.0, 15.0),
(2, 1, 2.0, 14.0),
(3, 1, 2.0, 15.5),
(4, 1, null, 5.0),
(8, 1, null, 5.0),
(12, 3, null, null),
(15, 3, null, null),
(21, 1, 0.9, 10);

/* strengthLog */

INSERT INTO strengthLog (exrLogID, strLogSets, strLogReps, strLogWeight) 
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
