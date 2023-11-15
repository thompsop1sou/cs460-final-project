use f23_motionSense;


CREATE TABLE trainer(
	trnID INT(4) NOT NULL,
    trnFirstName VARCHAR(35) NOT NULL,
    trnLastName VARCHAR(35) NOT NULL,
    trnEmail varchar(254),
    trnPhone VARCHAR(20)
);

ALTER TABLE trainer
	ADD CONSTRAINT trnPK
    PRIMARY KEY (trnID);
    
    
/********************  Doc and trainer needs to  be ran before athlete *****************/
    
CREATE TABLE athlete(
	athID INT(4) NOT NULL,
    trnID INT(4) NOT NULL,
    docID INT(4),
    athFirstName VARCHAR(35) NOT NULL,
    athLastName VARCHAR(35) NOT NULL,
    athDateOfBirth date,
    athEmail varchar(254),
    athPhone VARCHAR(20)
);

ALTER TABLE athlete
	ADD CONSTRAINT athPK
    PRIMARY KEY (athID);
    
ALTER TABLE athlete
   ADD CONSTRAINT athTrn
   FOREIGN KEY (trnID)
   REFERENCES trainer(trnID);
   
ALTER TABLE athlete
   ADD CONSTRAINT athDoc
   FOREIGN KEY (docID)
   REFERENCES doctor(docID);
   
   
/*************** workoutPlan needs to be ran before workoutLog***************/

CREATE TABLE workoutLog(
	wrkLogID INT(4) NOT NULL,
    wrkPlanID INT(4) NOT NULL,
    wrkLogDate date NOT NULL
);

ALTER TABLE workoutLog
	ADD CONSTRAINT wrkLogPK
    PRIMARY KEY (wrkLogID);

ALTER TABLE workoutLog
   ADD CONSTRAINT wrkPlanFK
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
   ADD CONSTRAINT exrPlanFK
   FOREIGN KEY (exrPlanID)
   REFERENCES exercisePlan(exrPlanID);
   
ALTER TABLE exerciseLog
   ADD CONSTRAINT wrkLogFK
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
   ADD CONSTRAINT cdoLogFK
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
   ADD CONSTRAINT strLogFK
   FOREIGN KEY (exrLogID)
   REFERENCES exerciseLog(exrLogID);

	
   