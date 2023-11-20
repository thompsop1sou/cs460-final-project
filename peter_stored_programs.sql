/*
VIEW

Description: This view will have all of the plans joined together by their relevant IDs.
Justification: This view could be used by athletes who want to see what their trainer has planned for them to do during a particular week.
Expected Execution: When it is used, it will be filtered by athlete ID and date, returning only plans for that athlete on that date.
*/

-- Taking a look at individual tables

SELECT * FROM exercise;
SELECT * FROM workoutPlan;
SELECT * FROM exercisePlan;
SELECT * FROM cardioPlan;
SELECT * FROM strengthPlan;

-- Joining workoutPlan and exercisePlan

SELECT * FROM workoutPlan LEFT JOIN exercisePlan USING(wrkPlanID);

-- Joining workoutPlan, exercisePlan, and exercise

SELECT * FROM workoutPlan LEFT JOIN exercisePlan USING(wrkPlanID) LEFT JOIN exercise USING(exrID);

SELECT wrkPlanID, athID, wrkPlanName, wrkPlanStartDate, wrkPlanEndDate, wrkPlanSchedule, exrName, exrType, exrPlanNotes
FROM workoutPlan LEFT JOIN exercisePlan USING(wrkPlanID) LEFT JOIN exercise USING(exrID);

-- Do I need to include info from cardioPlan and strengthPlan? There will be null values, which could be okay.



/*
PROCEDURE

Description:
Justification:
Expected Execution:
*/



/*
FUNCTION

Description:
Justification:
Expected Execution:
*/



/*
TRIGGER

Description:
Justification:
Expected Execution:
*/