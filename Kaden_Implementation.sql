USE f23_motionSense;


-- ***************** VIEW ************************

/* Creates a view that shows all trainers and the number of active athletes*/
DROP VIEW athPerTrn;
CREATE VIEW athPerTrn AS
SELECT t.trnID AS ID, t.trnFirstName AS FirstName, t.trnLastName AS LastName, count(athID) AS NumberofAthletes
FROM athlete a JOIN trainer t ON t.trnID = a.trnID WHERE a.athActive = TRUE GROUP BY t.trnID;

SELECT * FROM athPerTrn;


-- ***************** PROCEDURE ************************

/* Creates a procedure that show all avialable workouts for a athlete based on given
	dates*/
DELIMITER $$
CREATE PROCEDURE `availableWorkouts`(i_athID INT, i_startDate DATE, i_endDate DATE)
BEGIN
	SELECT wrkPlanID, athID, wrkPlanName, wrkPlanStartDate, wrkPlanEndDate, wrkPlanSchedule 
    FROM workoutPlan 
	WHERE athID = i_athID AND wrkPlanStartDate BETWEEN i_startDate AND i_endDate;
END$$

DELIMITER ;


-- ***************** FUNCTION ************************

/*Creates a fuction that that will return the progress an athlete has made for a specific exercise*/
DELIMITER $$
CREATE FUNCTION `exerciseProgress`(in_athID INT, in_exerciseName VARCHAR(100)) RETURNS decimal(10,0)
BEGIN
	-- Creating variables
	DECLARE o_progress DECIMAL;
    DECLARE l_exrType ENUM('Cardio', 'Strength');
    DECLARE firstInstance FLOAT;
    DECLARE lastInstance FLOAT;
    
    -- saving the type of workout
	SELECT exrType INTO l_exrType FROM exercise WHERE in_exerciseName = exrName;
    
    IF l_exrType = 'Strength' THEN
    -- creating a temp table to hold data on the exercise
		DROP TEMPORARY TABLE IF EXISTS exrProgress;
		CREATE TEMPORARY TABLE exrProgress AS
			SELECT
				wl.wrkLogDate AS logDate,
				sl.strLogWeight AS weightUsed
			FROM
				workoutLog wl
				JOIN workoutPlan wp ON wl.wrkPlanID = wp.wrkPlanID 
				JOIN exerciseLog el ON wl.wrkLogID = el.wrkLogID
				JOIN strengthLog sl ON el.exrLogID = sl.exrLogID
				JOIN exercisePlan ep ON el.exrPlanID = ep.exrPlanID
				JOIN exercise ex ON ep.exrID = ex.exrID
				JOIN athlete ath ON wp.athID = ath.athID
			WHERE
				ath.athID = in_athID
				AND ex.exrName = in_exerciseName;
            
            -- saving the first and last time the exercise was logged
            SET firstInstance = (SELECT weightUsed FROM exrProgress WHERE logDate = (SELECT min(logDate) FROM exrProgress));
            SET lastInstance = (SELECT weightUsed FROM exrProgress WHERE logDate = (SELECT max(logDate) FROM exrProgress));
            
            -- Determining the difference
            SET o_progress = lastInstance - firstInstance;
	ELSE 
        -- creating a temp table to hold data on the exercise
		DROP TEMPORARY TABLE IF EXISTS exrProgress;
		CREATE TEMPORARY TABLE exrProgress AS
			SELECT
				wl.wrkLogDate AS logDate,
				cl.cdoLogDuration AS duration
			FROM
				workoutLog wl
				JOIN workoutPlan wp ON wl.wrkPlanID = wp.wrkPlanID 
				JOIN exerciseLog el ON wl.wrkLogID = el.wrkLogID
				JOIN cardioLog cl ON el.exrLogID = cl.exrLogID
				JOIN exercisePlan ep ON el.exrPlanID = ep.exrPlanID
				JOIN exercise ex ON ep.exrID = ex.exrID
				JOIN athlete ath ON wp.athID = ath.athID
			WHERE
				ath.athID = in_athID
				AND ex.exrName = in_exerciseName;
				
			-- saving the first and last time the exercise was logged
            SET firstInstance = (SELECT duration FROM exrProgress WHERE logDate = (SELECT min(logDate) FROM exrProgress));
            SET lastInstance = (SELECT duration FROM exrProgress WHERE logDate = (SELECT max(logDate) FROM exrProgress));
            
			-- Determining the difference
            SET o_progress = (lastInstance - firstInstance);
	END IF;
    
    -- Returning 
	RETURN o_progress;
END$$

DELIMITER ;


-- ***************** TRIGGER ************************
DELIMITER $$
CREATE TRIGGER `f23_motionSense`.`workoutLog_BEFORE_INSERT` BEFORE INSERT ON `workoutLog` FOR EACH ROW
BEGIN
	-- Creating varibles
	DECLARE l_validStartDate DATE;
    DECLARE l_validEndDate DATE;
    
    -- saving the valid dates
	SELECT wrkPlanStartDate, wrkPlanEndDate 
    into l_validStartDate, l_validEndDate 
    FROM workoutPlan wp
    WHERE wp.wrkPlanID = NEW.wrkPlanID;
    
    -- Throw an error if the date entered is not valid and do not insert
    IF NEW.wrkLogDate NOT BETWEEN l_validStartDate and l_validEndDate then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Date entered is not valid for this plan';
	end if;
	
END$$

DELIMITER ;
