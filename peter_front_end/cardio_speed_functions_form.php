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
        <!-- Forms -->
        <p>
            <b>Input Form (Plan Function):</b>
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
                // Build query string
                $sql = "SELECT exrPlanID FROM cardioPlan";
                // Execute query using the connection created above
                $retval = mysqli_query($mysqli, $sql);

                // No results
                if (!(mysqli_num_rows($retval) > 0)) {
                    echo "<p><em>No cardio plans found in database.</em></p>\n";
                // Some results
                } else {
                    // Start of the form
                    echo "
        <form action=\"cardio_speed_functions_results.php\" method=\"post\">
            <p>
                <label for=\"cdo_plan_id\"> Cardio Plan ID: </label>
                <select id=\"cdo_plan_id\" name=\"cdo_plan_id\" required>";

                    // Add each cardio plan to the select field
                    while ($row = mysqli_fetch_assoc($retval)) {
                        echo "
                    <option value=\"" . $row["exrPlanID"] . "\">" . $row["exrPlanID"] . "</option>";
                    }

                    // End of the form
                    echo "
                </select>
            </p>
            <p>
                <input type=\"submit\" name=\"submit_plan\" value=\"Submit\">
            </p>
        </form>\n";
                }

                // Free result set
                mysqli_free_result($retval);
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
        <p>
            <b>Input Form (Log Function):</b>
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
                // Build query string
                $sql = "SELECT exrLogID FROM cardioLog";
                // Execute query using the connection created above
                $retval = mysqli_query($mysqli, $sql);

                // No results
                if (!(mysqli_num_rows($retval) > 0)) {
                    echo "<p><em>No cardio logs found in database.</em></p>\n";
                // Some results
                } else {
                    // Start of the form
                    echo "
        <form action=\"cardio_speed_functions_results.php\" method=\"post\">
            <p>
                <label for=\"cdo_log_id\"> Cardio Log ID: </label>
                <select id=\"cdo_log_id\" name=\"cdo_log_id\" required>";

                    // Add each cardio log to the select field
                    while ($row = mysqli_fetch_assoc($retval)) {
                        echo "
                    <option value=\"" . $row["exrLogID"] . "\">" . $row["exrLogID"] . "</option>";
                    }

                    // End of the form
                    echo "
                </select>
            </p>
            <p>
                <input type=\"submit\" name=\"submit_log\" value=\"Submit\">
            </p>
        </form>\n";
                }

                // Free result set
                mysqli_free_result($retval);
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>