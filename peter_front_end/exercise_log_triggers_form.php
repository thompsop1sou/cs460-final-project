<!doctype HTML>
<html>
    <head>
        <meta charset="UTF-8" />
        <title> Motion Sense - Exercise Log Triggers </title>
        <link rel="stylesheet" href="basic_style.css">
    </head>
    <body>
        <!-- Database project title -->
        <h1> <a href="index.html">Motion Sense</a> </h1>
        <!-- Page Title -->
        <h3> <a href="exercise_log_triggers_form.php">Exercise Log Triggers</a> </h3>
        <!-- Author -->
        <p>
            <b>Author:</b> Peter Thompson
        </p>
        <!-- Description -->
        <p>
            <b>Description:</b> These triggers ensure that data entered into the exerciseLog table
            is valid, which means that it refers to the same entry in the workoutPlan table whether
            you get there through the workoutLog table or through the exercisePlan table.
        </p>
        <!-- Justification -->
        <p>
            <b>Justification:</b> Because of a loop in our table relationships, it is possible that
            we could create an entry in the exerciseLog table that refers to one workoutPlan entry
            when you take one path and refers to a different workoutPlan entry when you take the
            other path. See the following image for an illustration of the two paths:
        </p>
        <img src="db_loop.png" alt="Database Loop">
        <!-- Expected Execution -->
        <p>
            <b>Expected Execution:</b> These triggers will be called automatically before an
            insertion or update on the exerciseLog table. If they find invalid data, they will
            throw an error and stop the insertion/update. Otherwise, they won't have any impact and
            will allow the insertion/update to proceed, in which case you will get to see the
            change in the database. (Note: This change will be immediately discarded so as not to
            cause any negative side effects to the functioning of the database.)
        </p>
        <p>
            Because of the complexity involved with UPDATE statements (trying to change data that
            is already connected to other bits of data), only the functionality of the INSERT
            trigger is shown here. First select the workout log that this new exercise log should
            be a part of. Then select the exercise plan that this new exercise log should be an
            instance of. Finally, enter a unique note so that this new log entry will be easy to
            find (optional). Some interesting inputs include:
        </p>
        <ul>
            <li>
                Workout log <b>2023-01-01 (wrkLogID 1, ref. wrkPlanID 1)</b> and exercise plan
                <b>Running (exrPlanID 1, ref. wrkPlanID 1)</b>.
                <ul>
                    <li>
                        Since these reference the same workout plan (ID 1), the UPDATE should
                        succeed, and you should see a new log entry in the database.
                    </li>
                </ul>
            </li>
            <li>
                Workout log <b>2023-01-01 (wrkLogID 1, ref. wrkPlanID 1)</b> and exercise plan
                <b>Running (exrPlanID 13, ref. wrkPlanID 4)</b>.
                <ul>
                    <li>
                        Although the exercise name is the same as before ("Running"), these now
                        reference two different workout plans (ID 1 and ID 4). So, the UPDATE
                        should fail, and you should see no change to the database
                    </li>
                </ul>
            </li>
        </ul>
        <!-- Form -->
        <p>
            <b>Input Form:</b>
        </p>
        <?php
            // Credientials
            require_once "/home/SOU/thompsop1/final_db_config.php";

            // Turn error reporting on
            error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
            ini_set("display_errors", "1");

            // Create connection using procedural interface
            $mysqli = mysqli_connect($hostname,$username,$password,$schema);

            // Check connection
            if (!$mysqli) {
                echo "<p><em>There was an error connecting to the database.</em></p>\n";
            } else {
                // Build query string A
                $sql_a = "SELECT wrkLogID, wrkPlanID, wrkLogDate FROM workoutLog";
                // Execute query A using the connection created above
                $retval_a = mysqli_query($mysqli, $sql_a);

                // Build query string B
                $sql_b = "SELECT wrkPlanID, exrName, exrPlanID FROM allPlanJoin";
                // Execute query B using the connection created above
                $retval_b = mysqli_query($mysqli, $sql_b);

                // No results in one of the queries
                if (!(mysqli_num_rows($retval_a) > 0) || !(mysqli_num_rows($retval_b) > 0)) {
                    echo "<p><em>No workouts found in database.</em></p>\n";
                // Some results in both queries
                } else {
                    // Start of the form
                    echo "
        <form action=\"exercise_log_triggers_results.php\" method=\"post\">
            <p>
                <label for=\"wrk_log_id\"> Workout Log: </label>
                <select id=\"wrk_log_id\" name=\"wrk_log_id\" required>";

                    // Add each workout log to the select field
                    while ($row = mysqli_fetch_assoc($retval_a)) {
                        echo  "
                    <option value=\"" . $row["wrkLogID"] . "\">" . $row["wrkLogDate"] . " (wrkLogID " . $row["wrkLogID"] . ", ref. wrkPlanID " . $row["wrkPlanID"] . ")</option>";
                    }

                    // Middle of the form
                    echo "
                </select>
            </p>
            <p>
                <label for=\"exr_plan_id\"> Exercise Plan: </label>
                <select id=\"exr_plan_id\" name=\"exr_plan_id\" required>";

                    // Add each exercise plan to the select field
                    while ($row = mysqli_fetch_assoc($retval_b)) {
                        echo "
                    <option value=\"" . $row["exrPlanID"] . "\">" . $row["exrName"] . " (exrPlanID " . $row["exrPlanID"] . ", ref. wrkPlanID " . $row["wrkPlanID"] . ")</option>";
                    }

                    // End of the form
                    echo "
                </select>
            </p>
            <p>
                <label for=\"exr_log_notes\"> Exercise Log Notes: </label>
                <input type=\"text\" id=\"exr_log_notes\" name=\"exr_log_notes\" value=\"THIS IS A TEST\">
            </p>
            <p>
                <input type=\"submit\" name=\"submit\" value=\"Submit\">
            </p>
        </form>\n";
                }

                // Free result sets
                mysqli_free_result($retval_a);
                mysqli_free_result($retval_b);
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>