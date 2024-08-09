# Motion Sense

*Designed and developed by Kaden Barker and Peter Thompson*

The Motion Sense database tracks workouts and exercises performed by athletes who are working with trainers. First, a trainer uses the database to plan a set of workouts for an athlete over a certain time period. Then, the athlete uses the database to log their completion of those workouts on particular days. Each workout is composed of a set of exercises, which allows for the planning and logging of each workout in great detail. Finally, the database is also designed to provide access to doctors who may be working with athletes recovering from injury.

## Documentation

The following documents were produced in the requirements and design phases for this project:

* [Requirements](https://docs.google.com/document/d/15oHoH3WrotgRKrjVFXm6prcx1WIoduby1bp_cC5ikdw/edit?usp=sharing)
* [Design](https://docs.google.com/document/d/1j0rhfNeemL06uOkV4fpsnGDMjTUvO5FwixdppFbJIXg/edit?usp=sharing)
  * [Entity-Relationship Diagram](erd.png)
  * [Data Dictionary](https://docs.google.com/spreadsheets/d/1bN0wgxMNZvg8it2yYvhtGEYcHWTLGdjvB823NCjt1io/edit?usp=sharing)
* [Implementation Plan](https://docs.google.com/document/d/1kDw4v5piNBHfNonx4EBtXBRnzcqgJQ1ptuzZpBBXhs8/edit?usp=sharing)

## Front End

The database previously had a front end that was available at https://cs460.sou.edu/~thompsop1/motion_sense/. The server has since been taken down, so the front end is no longer available. You can still find the code that was used to service the front end below.

## Code

The SQL, PHP, and HTML code that was used to create this database can be found in this GitHub repository. Here are some links directly to the various code files:

* SQL code to create database: [create_motion_sense.sql](create_motion_sense.sql)
* SQL code for stored programs (used by PHP pages below):
  * Kaden: [Kaden/Kaden_Implementation.sql](Kaden/Kaden_Implementation.sql)
  * Peter: [Peter/stored_programs.sql](Peter/stored_programs.sql)
* HTML landing page: [index.html](index.html)
* PHP code for front-end access to stored procedures:
  * Kaden:
    * A view that shows each Trainer and the number of active athletes: [Kaden/athPerTrnView.php](Kaden/athPerTrnView.php)
    * A procedure that shows all of your workouts provided by your trainer based on a date: [Kaden/getAvailableWorkouts.php](Kaden/getAvailableWorkouts.php)
    * A function to show progress in weight or duration of a specific exercise: [Kaden/exerciseProgress.php](Kaden/exerciseProgress.php)
    * A trigger that makes sure the date for this log is valid: [Kaden/insertWrkLog.php](Kaden/insertWrkLog.php)
  * Peter:
    * A view that joins all the plan tables: [Peter/all_plan_join_view.php](Peter/all_plan_join_view.php)
    * A procedure that shows an athlete's logs over a date range: [Peter/athlete_log_procedure.php](Peter/athlete_log_procedure.php)
    * Two functions that calculate the speed of a cardio exercise: [Peter/cardio_speed_functions.php](Peter/cardio_speed_functions.php)
    * Two triggers that validate data for the exerciseLog table: [Peter/exercise_log_triggers.php](Peter/exercise_log_triggers.php)
