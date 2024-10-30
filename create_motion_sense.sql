/* Create Tables */

/* trainer */

CREATE TABLE trainer(
    trn_id SERIAL,
    trn_first_name VARCHAR(35) NOT NULL,
    trn_last_name VARCHAR(35) NOT NULL,
    trn_email VARCHAR(254),
    trn_phone VARCHAR(20)
);

ALTER TABLE trainer
    ADD CONSTRAINT trn_pk
    PRIMARY KEY (trn_id);

/* doctor */

CREATE TABLE doctor(
    doc_id SERIAL,
    doc_first_name VARCHAR(35) NOT NULL,
    doc_last_name VARCHAR(35) NOT NULL,
    doc_email VARCHAR(254),
    doc_phone VARCHAR(20)
);

ALTER TABLE doctor
    ADD CONSTRAINT doc_pk
    PRIMARY KEY (doc_id);

/* athlete */
    
CREATE TABLE athlete(
    ath_id SERIAL,
    trn_id INT NOT NULL,
    doc_id INT,
    ath_first_name VARCHAR(35) NOT NULL,
    ath_last_name VARCHAR(35) NOT NULL,
    ath_date_of_birth DATE,
    ath_email VARCHAR(254),
    ath_phone VARCHAR(20),
    ath_active BOOLEAN NOT NULL DEFAULT TRUE
);

ALTER TABLE athlete
    ADD CONSTRAINT ath_pk
    PRIMARY KEY (ath_id);

ALTER TABLE athlete
    ADD CONSTRAINT ath_trn_fk
    FOREIGN KEY (trn_id)
    REFERENCES trainer(trn_id);

ALTER TABLE athlete
    ADD CONSTRAINT ath_doc_fk
    FOREIGN KEY (doc_id)
    REFERENCES doctor(doc_id);

/* exercise */

CREATE TYPE exercise_type AS ENUM ('cardio', 'strength');

CREATE TABLE exercise(
    exr_id SERIAL,
    exr_name VARCHAR(100) NOT NULL,
    exr_type exercise_type NOT NULL
);

ALTER TABLE exercise
    ADD CONSTRAINT exr_pk
    PRIMARY KEY (exr_id);

/* workout_plan */

CREATE TABLE workout_plan(
    wrk_plan_id SERIAL,
    ath_id INT NOT NULL,
    wrk_plan_name VARCHAR(100) NOT NULL,
    wrk_plan_start_date DATE NOT NULL,
    wrk_plan_end_date DATE NOT NULL,
    wrk_plan_schedule VARCHAR(100)
);

ALTER TABLE workout_plan
    ADD CONSTRAINT wrk_plan_pk
    PRIMARY KEY (wrk_plan_id);

ALTER TABLE workout_plan
    ADD CONSTRAINT wrk_plan_ath_fk
    FOREIGN KEY (ath_id)
    REFERENCES athlete(ath_id);

/* exercise_plan */

CREATE TABLE exercise_plan(
    exr_plan_id SERIAL,
    exr_id INT NOT NULL,
    wrk_plan_id INT NOT NULL,
    exr_plan_notes VARCHAR(100)
);

ALTER TABLE exercise_plan
    ADD CONSTRAINT exr_plan_pk
    PRIMARY KEY (exr_plan_id);

ALTER TABLE exercise_plan
    ADD CONSTRAINT exr_plan_exr_fk
    FOREIGN KEY (exr_id)
    REFERENCES exercise(exr_id);

ALTER TABLE exercise_plan
    ADD CONSTRAINT exr_plan_wrk_plan_fk
    FOREIGN KEY (wrk_plan_id)
    REFERENCES workout_plan(wrk_plan_id);

/* cardio_plan */

CREATE TABLE cardio_plan(
    exr_plan_id INT NOT NULL,
    cdo_plan_sets INT,
    cdo_plan_distance FLOAT,
    cdo_plan_duration FLOAT
);

ALTER TABLE cardio_plan
    ADD CONSTRAINT cdo_plan_pk
    PRIMARY KEY (exr_plan_id);

ALTER TABLE cardio_plan
    ADD CONSTRAINT cdo_plan_exr_plan_fk
    FOREIGN KEY (exr_plan_id)
    REFERENCES exercise_plan(exr_plan_id);

/* strength_plan */

CREATE TABLE strength_plan(
    exr_plan_id INT NOT NULL,
    str_plan_sets INT,
    str_plan_reps INT,
    str_plan_weight FLOAT
);

ALTER TABLE strength_plan
    ADD CONSTRAINT str_plan_pk
    PRIMARY KEY (exr_plan_id);

ALTER TABLE strength_plan
    ADD CONSTRAINT str_plan_exr_plan_fk
    FOREIGN KEY (exr_plan_id)
    REFERENCES exercise_plan(exr_plan_id);

/* workout_log */

CREATE TABLE workout_log(
    wrk_log_id SERIAL,
    wrk_plan_id INT NOT NULL,
    wrk_log_date DATE NOT NULL
);

ALTER TABLE workout_log
    ADD CONSTRAINT wrk_log_pk
    PRIMARY KEY (wrk_log_id);

ALTER TABLE workout_log
    ADD CONSTRAINT wrk_log_wrk_plan_fk
    FOREIGN KEY (wrk_plan_id)
    REFERENCES workout_plan(wrk_plan_id);

/* exercise_log */

CREATE TABLE exercise_log(
    exr_log_id SERIAL,
    exr_plan_id INT NOT NULL,
    wrk_log_id INT NOT NULL,
    exr_log_notes VARCHAR(100)
);

ALTER TABLE exercise_log
    ADD CONSTRAINT exr_log_pk
    PRIMARY KEY (exr_log_id);

ALTER TABLE exercise_log
    ADD CONSTRAINT exr_log_exr_plan_fk
    FOREIGN KEY (exr_plan_id)
    REFERENCES exercise_plan(exr_plan_id);

ALTER TABLE exercise_log
    ADD CONSTRAINT exr_log_wrk_log_fk
    FOREIGN KEY (wrk_log_id)
    REFERENCES workout_log(wrk_log_id);

/* cardio_log */

CREATE TABLE cardio_log(
    exr_log_id INT NOT NULL,
    cdo_log_sets INT,
    cdo_log_distance FLOAT,
    cdo_log_duration FLOAT
);

ALTER TABLE cardio_log
    ADD CONSTRAINT cdo_log_pk
    PRIMARY KEY (exr_log_id);

ALTER TABLE cardio_log
    ADD CONSTRAINT cdo_log_exr_log_fk
    FOREIGN KEY (exr_log_id)
    REFERENCES exercise_log(exr_log_id);

/* strength_log */

CREATE TABLE strength_log(
    exr_log_id INT NOT NULL,
    str_log_sets INT,
    str_log_reps INT,
    str_log_weight FLOAT
);

ALTER TABLE strength_log
    ADD CONSTRAINT str_log_pk
    PRIMARY KEY (exr_log_id);

ALTER TABLE strength_log
    ADD CONSTRAINT str_log_exr_log_fk
    FOREIGN KEY (exr_log_id)
    REFERENCES exercise_log(exr_log_id);



/* Populate Tables */

/* trainer */

INSERT INTO trainer (trn_id, trn_first_name, trn_last_name, trn_email, trn_phone)
VALUES
(1,'Timothy','Thomas', 'tthomas@example.com', '(541) 555-0000'),
(2,'Tracy','Taylor', 'ttaylor@example.com', '(541) 555-0001'),
(3,'Tanner','Thompson', 'tthompson@example.com', '(541) 555-0002'),
(4,'Tessa','Torres', 'ttorres@example.com', '(541) 555-0003'),
(5,'Terrance','Townsend', 'ttownsend@example.com', '(541) 555-0004');

/* doctor */

INSERT INTO doctor (doc_id, doc_first_name, doc_last_name, doc_email, doc_phone)
VALUES
(1,'Deborah','Davis', 'ddavis@example.com', '(541) 555-0020'),
(2,'Daniel','Diaz', 'ddiaz@example.com', '(541) 555-0021'),
(3,'Diana','Delgado', 'ddelgado@example.com', '(541) 555-0022'),
(4,'David','dixon', 'ddixon@example.com', '(541) 555-0023'),
(5,'Darcy','Dean', 'ddean@example.com', '(541) 555-0024');

/* athlete */

INSERT INTO athlete (ath_id, trn_id, doc_id, ath_first_name, ath_last_name, ath_date_of_birth, ath_email, ath_phone) 
VALUES
(1, 1, 1, 'Andrea', 'Adams', '2000-01-01', 'aadams@example.com', '(541) 555-0010'),
(2, 2, 2, 'Aaron', 'Anderson', '2000-01-02', 'aanderson@example.com', '(541) 555-0011'),
(3, 3, null, 'Amber', 'Alexander', '2000-01-03', 'aalexander@example.com', '(541) 555-0012'),
(4, 4, null, 'Abraham', 'Allen', '2000-01-04', 'aallen@example.com', '(541) 555-0013'),
(5, 5, 5, 'Amelia', 'Abbott', '2000-01-05', 'aabbott@example.com', '(541) 555-0014');

/* exercise */

INSERT INTO exercise (exr_id, exr_name, exr_type)
VALUES
(1, 'Running', 'cardio'),
(2, 'Swimming', 'cardio'),
(3, 'Rowing', 'cardio'),
(4, 'Biking', 'cardio'),
(5, 'Jump Rope', 'cardio'),
(6, 'Squat', 'strength'),
(7, 'Deadlift', 'strength'),
(8, 'Bench', 'strength'),
(9, 'Back Row', 'strength'),
(10, 'Pullup', 'strength'),
(11, 'Pushup', 'strength'),
(12, 'Situp', 'strength');

/* workout_plan */

INSERT INTO workout_plan (wrk_plan_id, ath_id, wrk_plan_name, wrk_plan_start_date, wrk_plan_end_date, wrk_plan_schedule)
VALUES
(1, 1, 'Run', '2023-01-01', '2023-01-15', 'Three times a week'),
(2, 2, 'Bodyweight Workout', '2023-02-02', '2023-02-22', 'Every Monday and Thursday'),
(3, 1, 'Lower Body Power', '2023-01-15', '2023-02-01', 'Three times a week'),
(4, 3, 'Full Body Workout', '2023-04-01', '2023-04-08', 'Two times a week'),
(5, 2, 'Swim', '2023-02-23', '2023-03-01', 'Four times a week');

/* exercise_plan */

INSERT INTO exercise_plan (exr_plan_id, exr_id, wrk_plan_id, exr_plan_notes)
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

/* cardio_plan */

INSERT INTO cardio_plan (exr_plan_id, cdo_plan_sets, cdo_plan_distance, cdo_plan_duration)
VALUES
(1, 1, 2.0, NULL),
(2, 1, NULL, 5.0),
(6, 3, NULL, 0.5),
(13, 1, NULL, 10.0),
(14, 5, 100.0, NULL);

/* strength_plan */

INSERT INTO strength_plan (exr_plan_id, str_plan_sets, str_plan_reps, str_plan_weight)
VALUES
(3, 3, 8, NULL),
(4, 3, 15, NULL),
(5, 3, 20, NULL),
(7, 4, 4, 145),
(8, 4, 4, 245),
(10, 3, 6, 200),
(11, 3, 6, 150),
(12, 3, 6, 120);

/* workout_log */

INSERT INTO workout_log (wrk_log_id, wrk_plan_id, wrk_log_date) 
VALUES
(1, 1, '2023-01-01'),
(2, 1, '2023-01-04'),
(3, 1, '2023-01-07'),
(4, 2, '2023-02-02'),
(5, 2, '2023-02-06'),
(7, 3, '2023-01-15'),
(8, 3, '2023-01-019'),
(9, 4, '2023-04-08');

/* exercise_log */

INSERT INTO exercise_log (exr_log_id, exr_plan_id, wrk_log_id, exr_log_notes) 
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
(18, 10, 9, 'feeling great today, did extra weight'),
(19, 11, 9, 'feeling great today, went up in weight'),
(20, 12, 9, 'feeling great today, went up in weight'),
(21, 13, 9, null);

/* cardio_log */

INSERT INTO cardio_log (exr_log_id, cdo_log_sets, cdo_log_distance, cdo_log_duration) 
VALUES
(1, 1, 2.0, 15.0),
(2, 1, 2.0, 14.0),
(3, 1, 2.0, 15.5),
(4, 1, null, 5.0),
(8, 1, null, 5.0),
(12, 3, null, null),
(15, 3, null, null),
(21, 1, 0.9, 10);

/* strength_log */

INSERT INTO strength_log (exr_log_id, str_log_sets, str_log_reps, str_log_weight) 
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
