use f23_motionSense;



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



CREATE TABLE exercise(
    exrID INT(4) NOT NULL,
    exrName VARCHAR(100) NOT NULL,
    exrType ENUM('Cardio', 'Strength') NOT NULL
);

ALTER TABLE exercise
    ADD CONSTRAINT exrPK
    PRIMARY KEY (exrID);


/********************  Doc and trainer needs to  be ran before athlete *****************/
    
CREATE TABLE athlete(
    athID INT(4) NOT NULL,
    trnID INT(4) NOT NULL,
    docID INT(4),
    athFirstName VARCHAR(35) NOT NULL,
    athLastName VARCHAR(35) NOT NULL,
    athDateOfBirth DATE,
    athEmail VARCHAR(254),
    athPhone VARCHAR(20)
);

ALTER TABLE athlete
	ADD athActive BOOLEAN 
    NOT NULL 
    DEFAULT TRUE;

ALTER TABLE athlete
    ADD CONSTRAINT athPK
    PRIMARY KEY (athID);

ALTER TABLE athlete
   ADD CONSTRAINT athTrnFK
   FOREIGN KEY (trnID)
   REFERENCES trainer(trnID);

ALTER TABLE athlete
   ADD CONSTRAINT athDocFK
   FOREIGN KEY (docID)
   REFERENCES doctor(docID);


/*************** athlete needs to be run before workoutPlan *****************/

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
    ADD CONSTRAINT wrkPlanAthFK
    FOREIGN KEY (athID)
    REFERENCES athlete(athID);


/*************** workoutPlan and exercise need to be run before exercisePlan **************/

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
    ADD CONSTRAINT exrPlanExrFK
    FOREIGN KEY (exrID)
    REFERENCES exercise(exrID);

ALTER TABLE exercisePlan
    ADD CONSTRAINT exrPlanWrkPlanFK
    FOREIGN KEY (wrkPlanID)
    REFERENCES workoutPlan(wrkPlanID);


/*************** exercisePlan needs to be run before cardioPlan and strengthPlan ***********/

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


/*************** workoutPlan needs to be ran before workoutLog***************/

CREATE TABLE workoutLog(
    wrkLogID INT(4) NOT NULL,
    wrkPlanID INT(4) NOT NULL,
    wrkLogDate DATE NOT NULL
);

ALTER TABLE workoutLog
    ADD CONSTRAINT wrkLogPK
    PRIMARY KEY (wrkLogID);

ALTER TABLE workoutLog
   ADD CONSTRAINT wrkLogWrkPlanFK
   FOREIGN KEY (wrkPlanID)
   REFERENCES workoutPlan(wrkPlanID);


/****************** exercisePlan and workoutLog needs to be ran before exerciseLog **************/

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
   ADD CONSTRAINT exrLogExrPlanFK
   FOREIGN KEY (exrPlanID)
   REFERENCES exercisePlan(exrPlanID);

ALTER TABLE exerciseLog
   ADD CONSTRAINT exrLogWrkLogFK
   FOREIGN KEY (wrkLogID)
   REFERENCES workoutLog(wrkLogID);


/***************** exerciseLog must be ran before the cardio and strength Logs*******/

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

/* Make all primary keys auto increment (except in cardio/strength tables) */

ALTER TABLE athlete
MODIFY COLUMN athID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE doctor
MODIFY COLUMN docID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE trainer
MODIFY COLUMN trnID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE exercise
MODIFY COLUMN exrID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE workoutPlan
MODIFY COLUMN wrkPlanID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE exercisePlan
MODIFY COLUMN exrPlanID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE workoutLog
MODIFY COLUMN wrkLogID INT(4) NOT NULL AUTO_INCREMENT;

ALTER TABLE exerciseLog
MODIFY COLUMN exrLogID INT(4) NOT NULL AUTO_INCREMENT;