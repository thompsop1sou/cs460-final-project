<!doctype HTML>
<html>
    <head>
        <meta charset="UTF-8" />
        <title> Motion Sense - Cardio Speed Functions </title>
        <link rel="stylesheet" href="basic_style.css">
    </head>
    <body>
        <!-- Database project title -->
        <h1> <a href="index.html">Motion Sense</a> </h1>
        <!-- Page Title -->
        <h3> <a href="cardio_speed_functions_form.php">Cardio Speed Functions</a> </h3>
                <!-- Author -->
                <p>
            <b>Author:</b> Peter Thompson
        </p>
        <!-- Description -->
        <p>
            <b>Description:</b> These two functions both calculate the average speed of a cardio
            exercise, using the distance and duration associated with the exercise. One function is
            for entries in the cardioPlan table; the other is for entries in the cardioLog table.
        </p>
        <!-- Justification -->
        <p>
            <b>Justification:</b> This could be used in a procedure or view which summarizes data
            from a plan or log. For example, if a trainer has planned for an athlete to run two
            miles in sixteen minutes, the athlete might want to be able to quickly see what pace
            they need to set in order to reach that goal.
        </p>
        <!-- Expected Execution -->
        <p>
            <b>Expected Execution:</b> Both functions require the ID of the cardio plan or log.
            They then use that ID to find the distance and duration and return the result of the
            distance divided by the duration. Some valid inputs include:
        </p>
        <ul>
            <li>
                Cardio <b>plan</b> with ID <b>1</b>.
                <ul>
                    <li>
                        This should return null because this cardio plan does not have a duration.
                    </li>
                </ul>
            </li>
            <li>
                Cardio <b>plan</b> with ID <b>2</b>.
                <ul>
                    <li>
                        This should return null because this cardio plan does not have a distance.
                    </li>
                </ul>
            </li>
            <li>
                Cardio <b>log</b> with ID <b>1</b>.
                <ul>
                    <li>
                        This should return 0.1333 (distance / duration = 2 / 15).
                    </li>
                </ul>
            </li>
            <li>
                Cardio <b>log</b> with ID <b>4</b>.
                <ul>
                    <li>
                        This should return null because this cardio log does not have a distance.
                    </li>
                </ul>
            </li>
            <li>
                Cardio <b>log</b> with ID <b>21</b>.
                <ul>
                    <li>
                        This should return 0.09 (distance / duration = 0.9 / 10).
                    </li>
                </ul>
            </li>
        </ul>
        <!-- Query Results -->
        <p>
            <b>Query Results:</b>
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
                echo "<p> <em>There was an error connecting to the database.</em> <p>";
            } else {
                // Want to call plan function
                if (isset($_POST["submit_plan"])) {
                    // Label for the results
                    echo "<p>Results for cardio plan with ID <b>" . $_POST["cdo_plan_id"] . "</b>:</p>";

                    // Build query string
                    $sql = "SELECT cdoPlanDistance, cdoPlanDuration, cardioPlanSpeedFunction(exrPlanID) AS cdoPlanSpeed FROM cardioPlan WHERE exrPlanID=" . $_POST["cdo_plan_id"];
                    // Execute query using the connection created above
                    $retval = mysqli_query($mysqli, $sql);

                    // Display the results
                    if (mysqli_num_rows($retval) > 0) {
                        // Start the table
                        echo "<table>" .
                            "<tr>" .
                            "<th>cdoPlanDistance</th>" .
                            "<th>cdoPlanDuration</th>" .
                            "<th>cdoPlanSpeed</th>" .
                            "<tr>";
                        // Show each row
                        while ($row = mysqli_fetch_assoc($retval)) {
                            echo "<tr>" .
                                "<td>" . ($row["cdoPlanDistance"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoPlanDuration"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoPlanSpeed"] ?? "NULL") . "</td>" .
                                "</tr>";
                        }
                        // End the table
                        echo "</table>";
                    // No results
                    } else {
                        echo "<p> <em>No results returned.</em> <p>";
                    }

                    // Free result set
                    mysqli_free_result($retval);
                // Want to call log function
                } elseif (isset($_POST["submit_log"])) {
                    // Label for the results
                    echo "<p>Results for cardio log with ID <b>" . $_POST["cdo_log_id"] . "</b>:</p>";

                    // Build query string
                    $sql = "SELECT cdoLogDistance, cdoLogDuration, cardioLogSpeedFunction(exrLogID) AS cdoLogSpeed FROM cardioLog WHERE exrLogID=" . $_POST["cdo_log_id"];
                    // Execute query using the connection created above
                    $retval = mysqli_query($mysqli, $sql);

                    // Display the results
                    if (mysqli_num_rows($retval) > 0) {
                        // Start the table
                        echo "<table>" .
                            "<tr>" .
                            "<th>cdoLogDistance</th>" .
                            "<th>cdoLogDuration</th>" .
                            "<th>cdoLogSpeed</th>" .
                            "<tr>";
                        // Show each row
                        while ($row = mysqli_fetch_assoc($retval)) {
                            echo "<tr>" .
                                "<td>" . ($row["cdoLogDistance"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogDuration"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogSpeed"] ?? "NULL") . "</td>" .
                                "</tr>";
                        }
                        // End the table
                        echo "</table>";
                    // No results
                    } else {
                        echo "<p> <em>No results returned.</em> <p>";
                    }

                    // Free result set
                    mysqli_free_result($retval);
                // Form was not submitted
                } else {
                    echo "<p> <em>No form data submitted.</em> <p>";
                }
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>