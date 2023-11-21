/*
VIEW

Title: allPlanJoin
Description: This view will have all of the plans (workout, exercise, cardio, and strength) joined together by their relevant IDs.
Justification: This view could be used by athletes who want to see what their trainer has planned for them to do during a particular week.
Expected Execution: When it is used, it will be filtered by athlete ID and date, returning only plans for that particular athlete on that particular date.
*/

-- Taking a look at individual tables

SELECT * FROM exercise;
SELECT * FROM workoutPlan;
SELECT * FROM exercisePlan;
SELECT * FROM cardioPlan;
SELECT * FROM strengthPlan;

-- Joining workoutPlan and exercisePlan

SELECT * FROM exercisePlan RIGHT JOIN workoutPlan USING(wrkPlanID);

-- Joining workoutPlan, exercisePlan, and exercise

SELECT * FROM exercisePlan RIGHT JOIN exercise USING(exrID) RIGHT JOIN workoutPlan USING(wrkPlanID);

SELECT wrkPlanID, athID, wrkPlanName, wrkPlanStartDate, wrkPlanEndDate, wrkPlanSchedule, exrName, exrType, exrPlanNotes
FROM exercisePlan RIGHT JOIN exercise USING(exrID) RIGHT JOIN workoutPlan USING(wrkPlanID);

-- Do I need to include info from cardioPlan and strengthPlan? There will be null values, which could be okay.
-- I could use this as a subquery in the main query, but it might be easier to save this as its own view instead.

SELECT cardioPlan.exrPlanID,
	cdoPlanSets, cdoPlanDistance, cdoPlanDuration,
	NULL AS strPlanSets, NULL AS strPlanReps, NULL AS strPlanWeight
FROM cardioPlan
UNION
SELECT strengthPlan.exrPlanID,
	NULL AS cdoPlanSets, NULL AS cdoPlanDistance, NULL AS cdoPlanDuration,
	strPlanSets, strPlanReps, strPlanWeight
FROM strengthPlan;

-- Final SELECT statement with workoutPlan, exercise, exercisePlan, cardioPlan, and strengthPlan tables
-- Note: Started with tables lower in the hierarchy, then right-joined them to tables higher up.
-- Note: This assumes the query above is already saved as a view called exercisePlanUnion.

SELECT wrkPlanID, athID, wrkPlanName, wrkPlanStartDate, wrkPlanEndDate, wrkPlanSchedule,
	exrName, exrType, exrPlanNotes,
	cdoPlanSets, cdoPlanDistance, cdoPlanDuration,
    strPlanSets, strPlanReps, strPlanWeight
FROM exercisePlanUnion
    RIGHT JOIN exercisePlan USING (exrPlanID)
    RIGHT JOIN exercise USING(exrID)
    RIGHT JOIN workoutPlan USING(wrkPlanID);

-- Testing to see if the two views work

SELECT * FROM exercisePlanUnion;
SELECT * FROM allPlanJoin;



/*
PROCEDURE

Title: athleteLogProcedure
Description: This procedure will return a result set containing all of the logs for a particular athlete during a particular date range.
Justification: This procedure could be used by trainers who want to see a report of what an athlete has done during the past week (or some other time period).
Expected Execution: Inputs to the procedure include the ID of the athlete, a start date, and an end date. The procedure will return a single result set which is 
*/

-- Building the views which will support this procedure.

-- Joining workoutLog with workoutPlan
-- Saved as a view called workoutLogPlanJoin

SELECT wrkLogID, athID, wrkPlanID, wrkPlanName, wrkLogDate FROM workoutLog LEFT JOIN workoutPlan USING(wrkPlanID);

-- Joining exerciseLog with exercisePlan and exercise
-- Saved as a view called exerciseLogPlanJoin

SELECT exrLogID, wrkLogID, exrPlanID, exrName, exrType, exrLogNotes FROM exerciseLog LEFT JOIN exercisePlan USING(exrPlanID) LEFT JOIN exercise USING(exrID);

-- Union of cardioLog and strengthLog
-- Saved as a view called exerciseLogUnion

SELECT cardioLog.exrLogID,
	cdoLogSets, cdoLogDistance, cdoLogDuration,
	NULL AS strLogSets, NULL AS strLogReps, NULL AS strLogWeight
FROM cardioLog
UNION
SELECT strengthLog.exrLogID,
	NULL AS cdoLogSets, NULL AS cdoLogDistance, NULL AS cdoLogDuration,
	strLogSets, strLogReps, strLogWeight
FROM strengthLog;

-- Putting them all together (where each of them has been saved as a view)
-- This one will be saved as a view called allLogJoin

SELECT wrkLogID, athID, wrkPlanID, wrkPlanName, wrkLogDate,
	exrName, exrType, exrLogNotes,
    cdoLogSets, cdoLogDistance, cdoLogDuration,
    strLogSets, strLogReps, strLogWeight
FROM exerciseLogUnion
    RIGHT JOIN exerciseLogPlanJoin USING(exrLogID)
    RIGHT JOIN workoutLogPlanJoin USING(wrkLogID);

-- Testing the views

SELECT * FROM workoutLogPlanJoin;
SELECT * FROM exerciseLogPlanJoin;
SELECT * FROM exerciseLogUnion;
SELECT * FROM allLogJoin;

-- Now actually creating the procedure using the saved views

/*
CREATE PROCEDURE athleteLogProcedure(inAthID INT, inStartDate DATE, inEndDate DATE)
BEGIN
	SELECT wrkPlanName, wrkLogDate,
		exrName, exrType, exrLogNotes,
        cdoLogSets, cdoLogDistance, cdoLogDuration,
        strLogSets, strLogReps, strLogWeight
	FROM allLogJoin
    WHERE athID = inAthID AND wrkLogDATE BETWEEN inStartDate AND inEndDate;
END
*/

-- Testing out procedure

CALL athleteLogProcedure(1, '2023-01-01', '2023-01-05');
CALL athleteLogProcedure(2, '2023-02-02', '2023-02-02');
CALL athleteLogProcedure(1, '2023-01-01', '2023-01-19');



/*
FUNCTION

Title: cardioPlanSpeedFunction and cardioPlanLogFunction
Description: Calculates the average speed of a cardio exercise (using the distance and duration associated with the exercise).
Justification: This could be used 
Expected Execution: It would take in the ID of the cardio exercise plan/log, then use that to find the distance and duration, then return the distance divided by the duration.
*/

-- Plan function

/*
CREATE FUNCTION cardioPlanSpeedFunction(inExrPlanID INT)
RETURNS FLOAT
READS SQL DATA
BEGIN
	DECLARE localDistance FLOAT DEFAULT NULL;
    DECLARE localDuration FLOAT DEFAULT NULL;
    
    SELECT cdoPlanDistance, cdoPlanDuration INTO localDistance, localDuration
    FROM cardioPlan WHERE exrPlanID = inExrPlanID;
    
    RETURN(localDistance / localDuration);
END
*/

-- Testing out plan function

SELECT * FROM cardioPlan;

SELECT cardioPlanSpeedFunction(0); -- Should be null because there is no exercise plan with ID 0
SELECT cardioPlanSpeedFunction(1); -- Should be null because this cardio plan does not have a duration
SELECT cardioPlanSpeedFunction(2); -- Should be null because this cardio plan does not have a distance
SELECT cardioPlanSpeedFunction(3); -- Should be null because this exercise plan ID refers to a strength plan (not to a cardio plan)

-- Log function

/*
CREATE FUNCTION cardioLogSpeedFunction(inExrLogID INT)
RETURNS FLOAT
READS SQL DATA
BEGIN
	DECLARE localDistance FLOAT DEFAULT NULL;
    DECLARE localDuration FLOAT DEFAULT NULL;
    
    SELECT cdoLogDistance, cdoLogDuration INTO localDistance, localDuration
    FROM cardioLog WHERE exrLogID = inExrLogID;
    
    RETURN(localDistance / localDuration);
END
*/

-- Testing out log function

SELECT * FROM cardioLog;

SELECT cardioLogSpeedFunction(0); -- Should be null because there is no exercise log with ID 0
SELECT cardioLogSpeedFunction(1); -- Should return 0.1333
SELECT cardioLogSpeedFunction(4); -- Should be null because this cardio log does not have a distance
SELECT cardioLogSpeedFunction(5); -- Should be null because this exercise log ID refers to a strength log (not to a cardio log)
SELECT cardioLogSpeedFunction(21); -- Should return 0.09



/*
TRIGGER

Title: exerciseLog_BEFORE_INSERT and exerciseLog_BEFORE_UPDATE
Description: These triggers ensure that data entered into the exerciseLog table is valid, which means that it refers to the same workoutPlan whether you get there through workoutLog or through exercisePlan.
Justification: Because of a loop in our table relationships, it is possible that we could create an exerciseLog that refers to one workoutPlan when you take one path and refers to a different workoutPlan when you take the other path.
Expected Execution: These triggers will be called automatically before an insertion or update on the exerciseLog table. If they find invalid data, they will throw an error and stop the insertion/update. Otherwise, they won't have any impact.
*/

-- Insert trigger

/*
CREATE TRIGGER exerciseLog_BEFORE_INSERT
BEFORE INSERT ON `exerciseLog`
FOR EACH ROW
BEGIN
	DECLARE localWrkPlanID1 INT;
    DECLARE localWrkPlanID2 INT;
    
    SELECT wrkPlanID INTO localWrkPlanID1 FROM workoutLog
    WHERE wrkLogID = NEW.wrkLogID;
    
    SELECT wrkPlanID INTO localWrkPlanID2 FROM exercisePlan
    WHERE exrPlanID = NEW.exrPlanID;
    
    IF localWrkPlanID1 != localWrkPlanID2 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Entry to exerciseLog table references two different entries in workoutPlan table.';
    END IF;
END
*/

-- Testing insert trigger

SELECT * FROM exercisePlan LEFT JOIN exercise USING(exrID);
SELECT * FROM workoutPlan;
SELECT * FROM workoutLog;
SELECT * FROM exerciseLog;

START TRANSACTION;

INSERT INTO workoutLog VALUES (100, 4, '2023-04-08'); -- Insert a new workoutLog that the exerciseLog can belong to

INSERT INTO exerciseLog VALUES (100, 7, 100, 'test log'); -- Should throw the custom error because it points to the wrong exercisePlanID (7)
INSERT INTO exerciseLog VALUES (100, 10, 100, 'test log'); -- Should be no problem because it points to the correct exercisePlanID (10)

ROLLBACK;

-- Update trigger

/*
CREATE TRIGGER exerciseLog_BEFORE_UPDATE
BEFORE UPDATE ON `exerciseLog`
FOR EACH ROW
BEGIN
	DECLARE localWrkPlanID1 INT;
    DECLARE localWrkPlanID2 INT;
    
    SELECT wrkPlanID INTO localWrkPlanID1 FROM workoutLog
    WHERE wrkLogID = NEW.wrkLogID;
    
    SELECT wrkPlanID INTO localWrkPlanID2 FROM exercisePlan
    WHERE exrPlanID = NEW.exrPlanID;
    
    IF localWrkPlanID1 != localWrkPlanID2 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Entry to exerciseLog table references two different entries in workoutPlan table.';
    END IF;
END
*/

-- Testing update trigger

START TRANSACTION;

UPDATE exerciseLog SET exrPlanID = 7 WHERE exrLogID = 18; -- Should throw the custom error because it points to the wrong exrPlanID (7 instead of 10)

ROLLBACK;