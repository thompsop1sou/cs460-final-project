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



/* Workout Plan here */


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







