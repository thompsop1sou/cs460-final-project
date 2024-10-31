/*
VIEW

Title: AllPlanJoin

Description: This view has all of the plan tables joined together by their relevant IDs.

Justification: Because the plan data is spread out over several different tables (WorkoutPlan,
Exercise, ExercisePlan, CardioPlan, and StrengthPlan), it can be tricky to query it all correctly.
This view does the work of joining all of the tables so that the data is easier to query. In a
practical sense, it could be used by athletes who want to see what their trainer has planned for
them to do during a particular week.

Expected Execution: The table below shows selected columns from the AllPlanJoin view as it
currently exists insIDe of the Motion Sense database. (Note that cardio exercises always have null
values in the StrPlanSets column while strength exercises always have null values in the
CdoPlanSets column. This is a result of the fact that the CardioPlan table has columns which the
StrengthPlan table does not have, and vice versa.)
*/

-- Union of CardioLog and StrengthLog
-- Saved as a view called ExercisePlanUnion

CREATE VIEW ExercisePlanUnion AS
SELECT CardioPlan.ExrPlanID,
	CdoPlanSets, CdoPlanDistance, CdoPlanDuration,
	NULL AS StrPlanSets, NULL AS StrPlanReps, NULL AS StrPlanWeight
FROM CardioPlan
UNION
SELECT StrengthPlan.ExrPlanID,
	NULL AS CdoPlanSets, NULL AS CdoPlanDistance, NULL AS CdoPlanDuration,
	StrPlanSets, StrPlanReps, StrPlanWeight
FROM StrengthPlan;

-- Joining all the plan tables together
-- Saved as the AllPlanJoin view
-- Note: Started with tables lower in the hierarchy, then right-joined them to tables higher up.

CREATE VIEW AllPlanJoin AS
SELECT *
FROM ExercisePlanUnion
    RIGHT JOIN ExercisePlan USING(ExrPlanID)
    RIGHT JOIN Exercise USING(ExrID)
    RIGHT JOIN WorkoutPlan USING(WrkPlanID);

-- Testing to see if the two views work

--SELECT * FROM ExercisePlanUnion;
--SELECT * FROM AllPlanJoin;



/*
PROCEDURE

Title: AthleteLogProcedure

Description: This procedure returns a result set containing all of the logs for a particular
athlete during a particular date range.

Justification: This procedure could be used by trainers who want to see a report of what an athlete
has done during the past week (or some other time period).

Expected Execution: Inputs to the procedure include the ID of the athlete, a start date, and an end
date. The procedure will return a table that includes all logs for the selected athlete over the
indicated date range.
*/

-- Building the views which will support this procedure.

-- Joining WorkoutLog with WorkoutPlan
-- Saved as a view called WorkoutLogPlanJoin

CREATE VIEW WorkoutLogPlanJoin AS
SELECT WrkLogID, AthID, WrkPlanID, WrkPlanName, WrkLogDate
FROM WorkoutLog LEFT JOIN WorkoutPlan USING(WrkPlanID);

-- Joining ExerciseLog with ExercisePlan and Exercise
-- Saved as a view called ExerciseLogPlanJoin

CREATE VIEW ExerciseLogPlanJoin AS
SELECT ExrLogID, WrkLogID, ExrPlanID, ExrName, ExrType, ExrLogNotes
FROM ExerciseLog LEFT JOIN ExercisePlan USING(ExrPlanID) LEFT JOIN Exercise USING(ExrID);

-- Union of CardioLog and StrengthLog
-- Saved as a view called ExerciseLogUnion

CREATE VIEW ExerciseLogUnion AS
SELECT CardioLog.ExrLogID,
	CdoLogSets, CdoLogDistance, CdoLogDuration,
	NULL AS StrLogSets, NULL AS StrLogReps, NULL AS StrLogWeight
FROM CardioLog
UNION
SELECT StrengthLog.ExrLogID,
	NULL AS CdoLogSets, NULL AS CdoLogDistance, NULL AS CdoLogDuration,
	StrLogSets, StrLogReps, StrLogWeight
FROM StrengthLog;

-- Putting them all together (where each of them has been saved as a view)
-- This one will be saved as a view called AllLogJoin

CREATE VIEW AllLogJoin AS
SELECT *
FROM ExerciseLogUnion
    RIGHT JOIN ExerciseLogPlanJoin USING(ExrLogID)
    RIGHT JOIN WorkoutLogPlanJoin USING(WrkLogID);

-- Testing the views

--SELECT * FROM WorkoutLogPlanJoin;
--SELECT * FROM ExerciseLogPlanJoin;
--SELECT * FROM ExerciseLogUnion;
--SELECT * FROM AllLogJoin;

-- Now actually creating the procedure using the saved views

CREATE OR REPLACE FUNCTION
    AthleteLogProcedure(InAthID INT, InStartDate DATE, InEndDate DATE)
RETURNS TABLE (WrkPlanName VARCHAR(100),
                WrkLogDate DATE,
                ExrName VARCHAR(100),
                ExrType ExerciseType,
                ExrLogNotes VARCHAR(100),
                CdoLogSets INT,
                CdoLogDistance FLOAT,
                CdoLogDuration FLOAT,
                StrLogSets INT,
                StrLogReps INT,
                StrLogWeight FLOAT)
AS $$
BEGIN
    RETURN QUERY
    SELECT AllLogJoin.WrkPlanName,
        AllLogJoin.WrkLogDate,
        AllLogJoin.ExrName,
        AllLogJoin.ExrType,
        AllLogJoin.ExrLogNotes,
        AllLogJoin.CdoLogSets,
        AllLogJoin.CdoLogDistance,
        AllLogJoin.CdoLogDuration,
        AllLogJoin.StrLogSets,
        AllLogJoin.StrLogReps,
        AllLogJoin.StrLogWeight
    FROM AllLogJoin
    WHERE AllLogJoin.AthID = InAthID
        AND AllLogJoin.WrkLogDate BETWEEN InStartDate AND InEndDate;
END;
$$ LANGUAGE plpgsql;

-- Testing out procedure

--SELECT * FROM AthleteLogProcedure(1, '2023-01-01', '2023-01-05');
--SELECT * FROM AthleteLogProcedure(2, '2023-02-02', '2023-02-06');
--SELECT * FROM AthleteLogProcedure(1, '2023-01-01', '2023-01-19');



/*
FUNCTION

Title: CardioPlanSpeedFunction and CardioLogSpeedFunction

Description: These two functions both calculate the average speed of a cardio exercise, using the
distance and duration associated with the exercise. One function is for entries in the CardioPlan
table; the other is for entries in the CardioLog table.

Justification: This could be used in a procedure or view which summarizes data from a plan or log.
For example, if a trainer has planned for an athlete to run two miles in sixteen minutes, the
athlete might want to be able to quickly see what pace they need to set in order to reach that
goal.

Expected Execution: Both functions require the ID of the cardio plan or log. They then use that ID
to find the distance and duration and return the result of the distance divIDed by the duration.
*/

-- Plan function

CREATE OR REPLACE FUNCTION CardioPlanSpeedFunction(InExrPlanID INT)
RETURNS FLOAT AS $$
DECLARE
	LocalDistance FLOAT DEFAULT NULL;
    LocalDuration FLOAT DEFAULT NULL;
BEGIN
    SELECT CdoPlanDistance, CdoPlanDuration INTO LocalDistance, LocalDuration
    FROM CardioPlan WHERE ExrPlanID = InExrPlanID;
    
    RETURN(LocalDistance / LocalDuration);
END;
$$ LANGUAGE plpgsql;

-- Testing out plan function

--SELECT CardioPlanSpeedFunction(0); -- Should be null because there is no exercise plan with ID 0
--SELECT CardioPlanSpeedFunction(1); -- Should be null because this cardio plan does not have a duration
--SELECT CardioPlanSpeedFunction(2); -- Should be null because this cardio plan does not have a distance
--SELECT CardioPlanSpeedFunction(3); -- Should be null because this exercise plan ID refers to a strength plan (not to a cardio plan)

-- Log function

CREATE FUNCTION CardioLogSpeedFunction(InExrLogID INT)
RETURNS FLOAT AS $$
DECLARE
	LocalDistance FLOAT DEFAULT NULL;
    LocalDuration FLOAT DEFAULT NULL;
BEGIN
    SELECT CdoLogDistance, CdoLogDuration INTO LocalDistance, LocalDuration
    FROM CardioLog WHERE ExrLogID = InExrLogID;
    
    RETURN(LocalDistance / LocalDuration);
END;
$$ LANGUAGE plpgsql;

-- Testing out log function

--SELECT CardioLogSpeedFunction(0); -- Should be null because there is no exercise log with ID 0
--SELECT CardioLogSpeedFunction(1); -- Should return 0.1333
--SELECT CardioLogSpeedFunction(4); -- Should be null because this cardio log does not have a distance
--SELECT CardioLogSpeedFunction(5); -- Should be null because this exercise log ID refers to a strength log (not to a cardio log)
--SELECT CardioLogSpeedFunction(21); -- Should return 0.09



/*
TRIGGER

Title: ExerciseLogTrigger

Description: This trigger ensures that data entered into the ExerciseLog table is valID, which
means that it refers to the same entry in the WorkoutPlan table whether you get there through the
WorkoutLog table or through the ExercisePlan table.

Justification: Because of a loop in our table relationships, it is possible that we could create an
entry in the ExerciseLog table that refers to one WorkoutPlan entry when you take one path and
refers to a different WorkoutPlan entry when you take the other path.

Expected Execution: This trigger will be called automatically before an insertion or update on
the ExerciseLog table. If it finds invalID data, it will throw an error and stop the
insertion/update. Otherwise, it won't have any impact and will allow the insertion/update to
proceed, in which case you will get to see the change in the database.
*/

-- Trigger function

CREATE OR REPLACE FUNCTION ExerciseLogTrigger()
RETURNS trigger AS $$
DECLARE
	LocalWrkPlanID1 INT;
    LocalWrkPlanID2 INT;
BEGIN
    SELECT WrkPlanID INTO LocalWrkPlanID1 FROM WorkoutLog
    WHERE WrkLogID = NEW.WrkLogID;
    
    SELECT WrkPlanID INTO LocalWrkPlanID2 FROM ExercisePlan
    WHERE ExrPlanID = NEW.ExrPlanID;
    
    IF LocalWrkPlanID1 != LocalWrkPlanID2 THEN
        RAISE EXCEPTION 'Entry to ExerciseLog table references two different entries in WorkoutPlan table';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger

CREATE TRIGGER ExerciseLogTrigger BEFORE INSERT OR UPDATE ON ExerciseLog
    FOR EACH ROW EXECUTE FUNCTION ExerciseLogTrigger();

-- Testing insert trigger

--BEGIN;

--INSERT INTO WorkoutLog VALUES (100, 4, '2023-04-08'); -- Insert a new WorkoutLog that the ExerciseLog can belong to

--INSERT INTO ExerciseLog VALUES (100, 7, 100, 'test log'); -- Should throw the custom error because it points to the wrong ExercisePlanID (7)
--INSERT INTO ExerciseLog VALUES (100, 10, 100, 'test log'); -- Should be no problem because it points to the correct ExercisePlanID (10)

--ROLLBACK;

-- Testing update trigger

--BEGIN;

--UPDATE ExerciseLog SET ExrPlanID = 7 WHERE ExrLogID = 18; -- Should throw the custom error because it points to the wrong ExrPlanID (7 instead of 10)

--ROLLBACK;