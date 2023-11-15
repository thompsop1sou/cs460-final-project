use f23_motionSense;


/* Filling the trainer Table*/
INSERT INTO trainer (trnID, trnFirstName, trnLastName, trnEmail, trnPhone) VALUES (1,'Timothy','Thomas', 'tthomas@example.com', '(541) 555-0000');
INSERT INTO trainer (trnID, trnFirstName, trnLastName, trnEmail, trnPhone) VALUES (2,'Tracy','Taylor', 'ttaylor@example.com', '(541) 555-0001');
INSERT INTO trainer (trnID, trnFirstName, trnLastName, trnEmail, trnPhone) VALUES (3,'Tanner','Thompson', 'tthompson@example.com', '(541) 555-0002');
INSERT INTO trainer (trnID, trnFirstName, trnLastName, trnEmail, trnPhone) VALUES (4,'Tessa','Torres', 'ttorres@example.com', '(541) 555-0003');
INSERT INTO trainer (trnID, trnFirstName, trnLastName, trnEmail, trnPhone) VALUES (5,'Terrance','Townsend', 'ttownsend@example.com', '(541) 555-0004');




/* Filling the doctor Table*/

INSERT INTO doctor (docID, docFirstName, docLastName, docEmail, docPhone) VALUES (1,'Deborah','Davis', 'ddavis@example.com', '(541) 555-0020');
INSERT INTO doctor (docID, docFirstName, docLastName, docEmail, docPhone) VALUES (2,'Daniel','Diaz', 'ddiaz@example.com', '(541) 555-0021');
INSERT INTO doctor (docID, docFirstName, docLastName, docEmail, docPhone) VALUES (3,'Diana','Delgado', 'ddelgado@example.com', '(541) 555-0022');
INSERT INTO doctor (docID, docFirstName, docLastName, docEmail, docPhone) VALUES (4,'David','dixon', 'ddixon@example.com', '(541) 555-0023');
INSERT INTO doctor (docID, docFirstName, docLastName, docEmail, docPhone) VALUES (5,'Darcy','Dean', 'ddean@example.com', '(541) 555-0024');

/* Filling the exercise table */
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

/* Filling the athlete Table*/

INSERT INTO athlete (athID, trnID, docID, athFirstName, athLastname, athDateOfBirth, athEmal, athPhone) 
VALUES (1, 1, 1, 'Andrea', 'Adams', '2000-01-01', 'aadams@example.com', '(541) 555-0010');
INSERT INTO athlete (athID, trnID, docID, athFirstName, athLastname, athDateOfBirth, athEmal, athPhone) 
VALUES (2, 2, 2, 'Aaron', 'Anderson', '2000-01-02', 'aanderson@example.com', '(541) 555-0011');
INSERT INTO athlete (athID, trnID, docID, athFirstName, athLastname, athDateOfBirth, athEmal, athPhone) 
VALUES (3, 3, null, 'Amber', 'Alexander', '2000-01-03', 'aalexander@example.com', '(541) 555-0012');
INSERT INTO athlete (athID, trnID, docID, athFirstName, athLastname, athDateOfBirth, athEmal, athPhone) 
VALUES (4, 4, null, 'Abraham', 'Allen', '2000-01-04', 'aallen@example.com', '(541) 555-0013');
INSERT INTO athlete (athID, trnID, docID, athFirstName, athLastname, athDateOfBirth, athEmal, athPhone) 
VALUES (5, 5, 5, 'Amelia', 'Abbott', '2000-01-05', 'aabbott@example.com', '(541) 555-0014');


/* Filling the workoutPlan table */
INSERT INTO workoutPlan (wrkPlanID, athID, wrkPlanStartDate, wrkPlanEndDate, wrkPlanSchedule)
VALUES
(1, 1, '2023-01-01', '2023-01-15', 'Three times a weekathID'),
(2, 2, '2023-02-02', '2023-02-22', 'Every Monday and Thursday'),
(3, 1, '2023-01-15', '2023-02-01', 'Three times a week'),
(4, 3, '2023-04-01', '2023-04-08', 'Two times a week'),
(5, 2, '2023-02-23', '2023-03-01', 'Four times a week');

/* Filling the exercisePlan table */
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

/* Filling the cardioPlan table */
INSERT INTO cardioPlan (exrPlanID, cdoPlanSets, cdoPlanDistance, cdoPlanDuration)
VALUES
(1, 1, 2.0, NULL),
(2, 1, NULL, 5.0),
(6, 3, NULL, 0.5),
(13, 1, NULL, 10.0),
(14, 5, 100.0, NULL);

/* Filling the strengthPlan table */
INSERT INTO exercisePlan (exrPlanID, strPlanSets, strPlanReps, strPlanWeight)
VALUES
(3, 3, 8, NULL),
(4, 3, 15, NULL),
(5, 3, 20, NULL),
(7, 4, 4, 145),
(8, 4, 4, 245),
(10, 3, 6, 200),
(11, 3, 6, 150),
(12, 3, 6, 120);

/* Filling the workoutLog Table */
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (1, 1, '2023-01-01');
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (2, 1, '2023-01-04');
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (3, 1, '2023-01-07');
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (4, 2, '2023-02-02');
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (5, 2, '2023-02-06');
/* why did we not make a log 6? */
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (7, 3, '2023-01-15');
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (8, 3, '2023-01-019');
INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate) 
VALUES (9, 4, '2023-04-08');


/* Exercise plan must be ran before exercise log */
/* filling out exerciseLog */

INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (1, 1, 1, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (2, 1, 2, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (2, 1, 3, 'tired today');
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (4, 2, 4, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (5, 3, 4, "couldn't quite get 8 pullups");
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (6, 4, 4, "couldn't quited get 15 pushups");
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (7, 5, 4, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (8, 2, 5, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (9, 3, 5, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (10, 4, 5, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (11, 5, 5, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (12, 6, 7, '30 seconds was easy');
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (13, 7, 7, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (14, 8, 7, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (15, 6, 8, '30 seconds was easy');
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (16, 7, 8, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (17, 8, 8, null);
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (18, 10, 9, 'feeling great today, did extra weight');
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (19, 11, 9, 'feeling great today, went up in weight');
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (20, 12, 9, 'feeling great today, went up in weight');
INSERT INTO exerciseLog (exrLogID, exrPlanID, wrkLogID, exrLogNotes) 
VALUES (21, 13, 9, null);



/* Filling out cardioLog table */

INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (1, 1, 2.0, 15.0);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (2, 1, 2.0, 14.0);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (3, 1, 2.0, 15.5);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (4, 1, null, 5.0);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (8, 1, null, 5.0);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (12, 3, null, null);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (15, 3, null, null);
INSERT INTO cardioLog (exrLogID, cdoLogSets, cdoLogDistance, cdoLogDuration) 
VALUES (21, 1, 0.9, 10);





/* Filling out strengthLog table */

INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (5, 3, 7, null);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (6, 3, 13, null);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (7, 3, 20, null);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (9, 3, 8, null);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (10, 3, 15, null);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (11, 3, 20, null);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (13, 4, 4, 145);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (14, 4, 4, 245);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (16, 4, 4, 145);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (17, 4, 4, 245);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (18, 3, 6, 215);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (19, 3, 6, 165);
INSERT INTO strengthLog (strLogID, strLogSets, strLogReps, strLogWeight) 
VALUES (20, 3, 6, 135);

