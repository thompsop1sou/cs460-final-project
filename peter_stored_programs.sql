/*
VIEW

Title: allPlanJoin

Description: This view has all of the plan tables joined together by their relevant IDs.

Justification: Because the plan data is spread out over several different tables (workoutPlan,
exercise, exercisePlan, cardioPlan, and strengthPlan), it can be tricky to query it all correctly.
This view does the work of joining all of the tables so that the data is easier to query. In a
practical sense, it could be used by athletes who want to see what their trainer has planned for
them to do during a particular week.

Expected Execution: The table below shows selected columns from the allPlanJoin view as it
currently exists inside of the Motion Sense database. (Note that cardio exercises always have null
values in the strPlanSets column while strength exercises always have null values in the
cdoPlanSets column. This is a result of the fact that the cardioPlan table has columns which the
strengthPlan table does not have, and vice versa.)
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
-- Decided to save as a view called exercisePlanUnion.

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

SELECT *
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

Description: This procedure returns a result set containing all of the logs for a particular
athlete during a particular date range.

Justification: This procedure could be used by trainers who want to see a report of what an athlete
has done during the past week (or some other time period).

Expected Execution: Inputs to the procedure include the ID of the athlete, a start date, and an end
date. The procedure will return a table that includes all logs for the selected athlete over the
indicated date range.
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

SELECT *
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
CALL athleteLogProcedure(2, '2023-02-02', '2023-02-06');
CALL athleteLogProcedure(1, '2023-01-01', '2023-01-19');



/*
FUNCTION

Title: cardioPlanSpeedFunction and cardioLogSpeedFunction

Description: These two functions both calculate the average speed of a cardio exercise, using the
distance and duration associated with the exercise. One function is for entries in the cardioPlan
table; the other is for entries in the cardioLog table.

Justification: This could be used in a procedure or view which summarizes data from a plan or log.
For example, if a trainer has planned for an athlete to run two miles in sixteen minutes, the
athlete might want to be able to quickly see what pace they need to set in order to reach that
goal.

Expected Execution: Both functions require the ID of the cardio plan or log. They then use that ID
to find the distance and duration and return the result of the distance divided by the duration.
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
SELECT cdoLogDistance, cdoLogDuration FROM cardioLog WHERE exrLogID=1;
SELECT cardioLogSpeedFunction(1); -- Should return 0.1333
SELECT cardioLogSpeedFunction(4); -- Should be null because this cardio log does not have a distance
SELECT cardioLogSpeedFunction(5); -- Should be null because this exercise log ID refers to a strength log (not to a cardio log)
SELECT cdoLogDistance, cdoLogDuration FROM cardioLog WHERE exrLogID=21;
SELECT cardioLogSpeedFunction(21); -- Should return 0.09



/*
TRIGGER

Title: exerciseLog_BEFORE_INSERT and exerciseLog_BEFORE_UPDATE

Description: These triggers ensure that data entered into the exerciseLog table is valid, which
means that it refers to the same entry in the workoutPlan table whether you get there through the
workoutLog table or through the exercisePlan table.

Justification: Because of a loop in our table relationships, it is possible that we could create an
entry in the exerciseLog table that refers to one workoutPlan entry when you take one path and
refers to a different workoutPlan entry when you take the other path.

Expected Execution: These triggers will be called automatically before an insertion or update on
the exerciseLog table. If they find invalid data, they will throw an error and stop the
insertion/update. Otherwise, they won't have any impact and will allow the insertion/update to
proceed, in which case you will get to see the change in the database.
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
		SET MESSAGE_TEXT = 'Entry to exerciseLog table references two different entries in workoutPlan table';
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
		SET MESSAGE_TEXT = 'Entry to exerciseLog table references two different entries in workoutPlan table';
    END IF;
END
*/

-- Testing update trigger

START TRANSACTION;

UPDATE exerciseLog SET exrPlanID = 7 WHERE exrLogID = 18; -- Should throw the custom error because it points to the wrong exrPlanID (7 instead of 10)

ROLLBACK;