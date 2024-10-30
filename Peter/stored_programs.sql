/*
VIEW

Title: all_plan_join

Description: This view has all of the plan tables joined together by their relevant IDs.

Justification: Because the plan data is spread out over several different tables (workout_plan,
exercise, exercise_plan, cardio_plan, and strength_plan), it can be tricky to query it all correctly.
This view does the work of joining all of the tables so that the data is easier to query. In a
practical sense, it could be used by athletes who want to see what their trainer has planned for
them to do during a particular week.

Expected Execution: The table below shows selected columns from the all_plan_join view as it
currently exists inside of the Motion Sense database. (Note that cardio exercises always have null
values in the str_plan_sets column while strength exercises always have null values in the
cdo_plan_sets column. This is a result of the fact that the cardio_plan table has columns which the
strength_plan table does not have, and vice versa.)
*/

-- Union of cardio_log and strength_log
-- Saved as a view called exercise_plan_union

CREATE VIEW exercise_plan_union AS
SELECT cardio_plan.exr_plan_id,
	cdo_plan_sets, cdo_plan_distance, cdo_plan_duration,
	NULL AS str_plan_sets, NULL AS str_plan_reps, NULL AS str_plan_weight
FROM cardio_plan
UNION
SELECT strength_plan.exr_plan_id,
	NULL AS cdo_plan_sets, NULL AS cdo_plan_distance, NULL AS cdo_plan_duration,
	str_plan_sets, str_plan_reps, str_plan_weight
FROM strength_plan;

-- Joining all the plan tables together
-- Saved as the all_plan_join view
-- Note: Started with tables lower in the hierarchy, then right-joined them to tables higher up.

CREATE VIEW all_plan_join AS
SELECT *
FROM exercise_plan_union
    RIGHT JOIN exercise_plan USING(exr_plan_id)
    RIGHT JOIN exercise USING(exr_id)
    RIGHT JOIN workout_plan USING(wrk_plan_id);

-- Testing to see if the two views work

--SELECT * FROM exercise_plan_union;
--SELECT * FROM all_plan_join;



/*
PROCEDURE

Title: athlete_log_procedure

Description: This procedure returns a result set containing all of the logs for a particular
athlete during a particular date range.

Justification: This procedure could be used by trainers who want to see a report of what an athlete
has done during the past week (or some other time period).

Expected Execution: Inputs to the procedure include the ID of the athlete, a start date, and an end
date. The procedure will return a table that includes all logs for the selected athlete over the
indicated date range.
*/

-- Building the views which will support this procedure.

-- Joining workout_log with workout_plan
-- Saved as a view called workout_log_plan_join

CREATE VIEW workout_log_plan_join AS
SELECT wrk_log_id, ath_id, wrk_plan_id, wrk_plan_name, wrk_log_date
FROM workout_log LEFT JOIN workout_plan USING(wrk_plan_id);

-- Joining exercise_log with exercise_plan and exercise
-- Saved as a view called exercise_log_plan_join

CREATE VIEW exercise_log_plan_join AS
SELECT exr_log_id, wrk_log_id, exr_plan_id, exr_name, exr_type, exr_log_notes
FROM exercise_log LEFT JOIN exercise_plan USING(exr_plan_id) LEFT JOIN exercise USING(exr_id);

-- Union of cardio_log and strength_log
-- Saved as a view called exercise_log_union

CREATE VIEW exercise_log_union AS
SELECT cardio_log.exr_log_id,
	cdo_log_sets, cdo_log_distance, cdo_log_duration,
	NULL AS str_log_sets, NULL AS str_log_reps, NULL AS str_log_weight
FROM cardio_log
UNION
SELECT strength_log.exr_log_id,
	NULL AS cdo_log_sets, NULL AS cdo_log_distance, NULL AS cdo_log_duration,
	str_log_sets, str_log_reps, str_log_weight
FROM strength_log;

-- Putting them all together (where each of them has been saved as a view)
-- This one will be saved as a view called all_log_join

CREATE VIEW all_log_join AS
SELECT *
FROM exercise_log_union
    RIGHT JOIN exercise_log_plan_join USING(exr_log_id)
    RIGHT JOIN workout_log_plan_join USING(wrk_log_id);

-- Testing the views

--SELECT * FROM workout_log_plan_join;
--SELECT * FROM exercise_log_plan_join;
--SELECT * FROM exercise_log_union;
--SELECT * FROM all_log_join;

-- Now actually creating the procedure using the saved views

CREATE OR REPLACE FUNCTION
    athlete_log_procedure(in_ath_id INT, in_start_date DATE, in_end_date DATE)
RETURNS TABLE (wrk_plan_name VARCHAR(100),
                wrk_log_date DATE,
                exr_name VARCHAR(100),
                exr_type exercise_type,
                exr_log_notes VARCHAR(100),
                cdo_log_sets INT,
                cdo_log_distance FLOAT,
                cdo_log_duration FLOAT,
                str_log_sets INT,
                str_log_reps INT,
                str_log_weight FLOAT)
AS $$
BEGIN
    RETURN QUERY
    SELECT all_log_join.wrk_plan_name,
        all_log_join.wrk_log_date,
        all_log_join.exr_name,
        all_log_join.exr_type,
        all_log_join.exr_log_notes,
        all_log_join.cdo_log_sets,
        all_log_join.cdo_log_distance,
        all_log_join.cdo_log_duration,
        all_log_join.str_log_sets,
        all_log_join.str_log_reps,
        all_log_join.str_log_weight
    FROM all_log_join
    WHERE all_log_join.ath_id = in_ath_id
        AND all_log_join.wrk_log_date BETWEEN in_start_date AND in_end_date;
END;
$$ LANGUAGE plpgsql;

-- Testing out procedure

--SELECT * FROM athlete_log_procedure(1, '2023-01-01', '2023-01-05');
--SELECT * FROM athlete_log_procedure(2, '2023-02-02', '2023-02-06');
--SELECT * FROM athlete_log_procedure(1, '2023-01-01', '2023-01-19');



/*
FUNCTION

Title: cardio_plan_speed_function and cardio_log_speed_function

Description: These two functions both calculate the average speed of a cardio exercise, using the
distance and duration associated with the exercise. One function is for entries in the cardio_plan
table; the other is for entries in the cardio_log table.

Justification: This could be used in a procedure or view which summarizes data from a plan or log.
For example, if a trainer has planned for an athlete to run two miles in sixteen minutes, the
athlete might want to be able to quickly see what pace they need to set in order to reach that
goal.

Expected Execution: Both functions require the ID of the cardio plan or log. They then use that ID
to find the distance and duration and return the result of the distance divided by the duration.
*/

-- Plan function

CREATE OR REPLACE FUNCTION cardio_plan_speed_function(in_exr_plan_id INT)
RETURNS FLOAT AS $$
DECLARE
	local_distance FLOAT DEFAULT NULL;
    local_duration FLOAT DEFAULT NULL;
BEGIN
    SELECT cdo_plan_distance, cdo_plan_duration INTO local_distance, local_duration
    FROM cardio_plan WHERE exr_plan_id = in_exr_plan_id;
    
    RETURN(local_distance / local_duration);
END;
$$ LANGUAGE plpgsql;

-- Testing out plan function

--SELECT cardio_plan_speed_function(0); -- Should be null because there is no exercise plan with ID 0
--SELECT cardio_plan_speed_function(1); -- Should be null because this cardio plan does not have a duration
--SELECT cardio_plan_speed_function(2); -- Should be null because this cardio plan does not have a distance
--SELECT cardio_plan_speed_function(3); -- Should be null because this exercise plan ID refers to a strength plan (not to a cardio plan)

-- Log function

CREATE FUNCTION cardio_log_speed_function(in_exr_log_id INT)
RETURNS FLOAT AS $$
DECLARE
	local_distance FLOAT DEFAULT NULL;
    local_duration FLOAT DEFAULT NULL;
BEGIN
    SELECT cdo_log_distance, cdo_log_duration INTO local_distance, local_duration
    FROM cardio_log WHERE exr_log_id = in_exr_log_id;
    
    RETURN(local_distance / local_duration);
END;
$$ LANGUAGE plpgsql;

-- Testing out log function

--SELECT cardio_log_speed_function(0); -- Should be null because there is no exercise log with ID 0
--SELECT cardio_log_speed_function(1); -- Should return 0.1333
--SELECT cardio_log_speed_function(4); -- Should be null because this cardio log does not have a distance
--SELECT cardio_log_speed_function(5); -- Should be null because this exercise log ID refers to a strength log (not to a cardio log)
--SELECT cardio_log_speed_function(21); -- Should return 0.09



/*
TRIGGER

Title: exercise_log_trigger

Description: This trigger ensures that data entered into the exercise_log table is valid, which
means that it refers to the same entry in the workout_plan table whether you get there through the
workout_log table or through the exercise_plan table.

Justification: Because of a loop in our table relationships, it is possible that we could create an
entry in the exercise_log table that refers to one workout_plan entry when you take one path and
refers to a different workout_plan entry when you take the other path.

Expected Execution: This trigger will be called automatically before an insertion or update on
the exercise_log table. If it finds invalid data, it will throw an error and stop the
insertion/update. Otherwise, it won't have any impact and will allow the insertion/update to
proceed, in which case you will get to see the change in the database.
*/

-- Trigger function

CREATE OR REPLACE FUNCTION exercise_log_trigger()
RETURNS trigger AS $$
DECLARE
	local_wrk_plan_id1 INT;
    local_wrk_plan_id2 INT;
BEGIN
    SELECT wrk_plan_id INTO local_wrk_plan_id1 FROM workout_log
    WHERE wrk_log_id = NEW.wrk_log_id;
    
    SELECT wrk_plan_id INTO local_wrk_plan_id2 FROM exercise_plan
    WHERE exr_plan_id = NEW.exr_plan_id;
    
    IF local_wrk_plan_id1 != local_wrk_plan_id2 THEN
        RAISE EXCEPTION 'Entry to exercise_log table references two different entries in workout_plan table';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger

CREATE TRIGGER exercise_log_trigger BEFORE INSERT OR UPDATE ON exercise_log
    FOR EACH ROW EXECUTE FUNCTION exercise_log_trigger();

-- Testing insert trigger

--BEGIN;

--INSERT INTO workout_log VALUES (100, 4, '2023-04-08'); -- Insert a new workout_log that the exercise_log can belong to

--INSERT INTO exercise_log VALUES (100, 7, 100, 'test log'); -- Should throw the custom error because it points to the wrong exercise_plan_id (7)
--INSERT INTO exercise_log VALUES (100, 10, 100, 'test log'); -- Should be no problem because it points to the correct exercise_plan_id (10)

--ROLLBACK;

-- Testing update trigger

--BEGIN;

--UPDATE exercise_log SET exr_plan_id = 7 WHERE exr_log_id = 18; -- Should throw the custom error because it points to the wrong exr_plan_id (7 instead of 10)

--ROLLBACK;