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
        <!-- Query Results -->
        <p>
            <b>Query Results:</b>
        </p>
        <?php
            // Function to display log data (used twice below)
            function display_log_data($mysqli) {
                // Build query string
                $sql = "SELECT wrkPlanName, wrkLogDate, exrName, exrType, exrLogNotes FROM allLogJoin";
                // Execute query using the connection created above
                $retval = mysqli_query($mysqli, $sql);

                // Display the results
                if (mysqli_num_rows($retval) > 0) {
                    // Start the table
                    echo "
        <table>
            <tr>
                <th>wrkPlanName</th>
                <th>wrkLogDate</th>
                <th>exrName</th>
                <th>exrType</th>
                <th>exrLogNotes</th>
            <tr>";
                    // Show each row
                    while ($row = mysqli_fetch_assoc($retval)) {
                        echo "
            <tr>
                <td>" . ($row["wrkPlanName"] ?? "NULL") . "</td>
                <td>" . ($row["wrkLogDate"] ?? "NULL") . "</td>
                <td>" . ($row["exrName"] ?? "NULL") . "</td>
                <td>" . ($row["exrType"] ?? "NULL") . "</td>
                <td>" . ($row["exrLogNotes"] ?? "NULL") . "</td>
            </tr>";
                    }
                    // End the table
                    echo "
        </table>";
                // No results
                } else {
                    echo "<p> <em>No log results.</em> <p>";
                }
            }

            // Credientials
            require_once "/home/SOU/thompsop1/final_db_config.php";

            // Turn error reporting on
            error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
            ini_set("display_errors", "1");

            // Create connection using procedural interface
            $mysqli = mysqli_connect($hostname,$username,$password,$schema);

            // Check connection
            if (!$mysqli) {
                echo "
        <p> <em>There was an error connecting to the database.</em> <p>";
            } else {
                // Make sure the form was actually submitted
                if (!isset($_POST["submit"])) {
                    echo "
        <p> <em>No form data submitted.</em> <p>";
                } else {
                    // Turn off autocommit
                    mysqli_autocommit($mysqli, false);

                    // Display log data before update/insert
                    echo "
        <p> Original log data: </p>";
                    display_log_data($mysqli);

                    // Attempt to insert the new data
                    try {
                        // Attempt to create new entry in exerciseLog table
                        $sql = "INSERT INTO exerciseLog (exrLogID, wrkLogID, exrPlanID, exrLogNotes) VALUES (NULL, " . $_POST["wrk_log_id"] . ", " . $_POST["exr_plan_id"] . ", '" . $_POST["exr_log_notes"] . "')";
                        mysqli_query($mysqli, $sql);
                        // If no error, indicate success
                        echo "
        <p> Insert succeeded! </p>";
                    } catch (mysqli_sql_exception $e) {
                        echo "
        <p> There was an error when inserting: " . mysqli_error($mysqli) . " </p>";
                    }

                    // Display log data after update/insert
                    echo "
        <p> Changed log data: </p>";
                    display_log_data($mysqli);
                }

                // Rollback any changes
                mysqli_rollback($mysqli);
            }

            // Close connection
            mysqli_close($mysqli);
        ?>

    </body>
</html>