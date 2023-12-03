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
        <h3> <a href="cardio_speed_functions.php">Cardio Speed Functions</a> </h3>
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
        <?php
            // Function to generate forms (used twice below)
            function generate_cardio_form($mysqli, $type)
            {
                // Form title
                echo "<p> <b>Input Form (" . $type . " Function):</b> </p>\n";

                // Build query string
                $sql = "SELECT exr" . $type . "ID FROM cardio" . $type;
                // Execute query using the connection created above
                $retval = mysqli_query($mysqli, $sql);

                // No results
                if (!(mysqli_num_rows($retval) > 0))
                {
                    echo "<p><em>No cardio " . strtolower($type) . "s found in database.</em></p>\n";
                }
                // Some results
                else
                {
                    // Start of the form
                    echo "<form action=\"cardio_speed_functions.php\" method=\"post\">\n" .
                        "<p>\n" .
                        "<label for=\"cdo_" . strtolower($type) . "_id\"> Cardio " . $type . " ID: </label>\n" .
                        "<select id=\"cdo_" . strtolower($type) . "_id\" name=\"cdo_" . strtolower($type) . "_id\" required>\n";

                    // Add each cardio plan to the select field
                    while ($row = mysqli_fetch_assoc($retval))
                    {
                        echo "<option value=\"" . $row["exr" . $type . "ID"] . "\">" . $row["exr" . $type . "ID"] . "</option>\n";
                    }

                    // End of the form
                    echo "</select>\n" .
                        "</p>\n" .
                        "<p>\n" .
                        "<input type=\"submit\" name=\"submit_" . strtolower($type) . "\" value=\"Submit\">\n" .
                        "</p>\n" .
                        "</form>\n";
                }

                // Free result set
                mysqli_free_result($retval);

            }

            // Credientials
            require_once "/home/SOU/thompsop1/final_db_config.php";

            // Turn error reporting on
            error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
            ini_set("display_errors", "1");

            // Create connection using procedural interface
            $mysqli = mysqli_connect($hostname,$username,$password,$schema);

            // Connection failed
            if (!$mysqli)
            {
                echo "<p> <em>There was an error connecting to the database.</em> <p>\n";
            }
            // Connection succeeded
            else
            {
                // Plan form already submitted, display the results
                if (isset($_POST["submit_plan"]))
                {
                    echo "<p> <b>Query Results:</b> </p>\n";

                    // Label for the results
                    echo "<p>Results for cardio plan with ID <b>" . $_POST["cdo_plan_id"] . "</b>:</p>";

                    // Build query string
                    $sql = "SELECT cdoPlanDistance, cdoPlanDuration, cardioPlanSpeedFunction(exrPlanID) AS cdoPlanSpeed FROM cardioPlan WHERE exrPlanID=" . $_POST["cdo_plan_id"];
                    // Execute query using the connection created above
                    $retval = mysqli_query($mysqli, $sql);

                    // Display the results
                    if (mysqli_num_rows($retval) > 0)
                    {
                        // Start the table
                        echo "<table>" .
                            "<tr>" .
                            "<th>cdoPlanDistance</th>" .
                            "<th>cdoPlanDuration</th>" .
                            "<th>cdoPlanSpeed</th>" .
                            "<tr>";
                        // Show each row
                        while ($row = mysqli_fetch_assoc($retval))
                        {
                            echo "<tr>" .
                                "<td>" . ($row["cdoPlanDistance"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoPlanDuration"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoPlanSpeed"] ?? "NULL") . "</td>" .
                                "</tr>";
                        }
                        // End the table
                        echo "</table>";
                    }
                    // No results
                    else
                    {
                        echo "<p> <em>No results returned.</em> <p>";
                    }

                    // Free result set
                    mysqli_free_result($retval);
                }
                // Log form already submitted, display the results
                elseif (isset($_POST["submit_log"]))
                {
                    echo "<p> <b>Query Results:</b> </p>\n";

                    // Label for the results
                    echo "<p>Results for cardio log with ID <b>" . $_POST["cdo_log_id"] . "</b>:</p>";

                    // Build query string
                    $sql = "SELECT cdoLogDistance, cdoLogDuration, cardioLogSpeedFunction(exrLogID) AS cdoLogSpeed FROM cardioLog WHERE exrLogID=" . $_POST["cdo_log_id"];
                    // Execute query using the connection created above
                    $retval = mysqli_query($mysqli, $sql);

                    // Display the results
                    if (mysqli_num_rows($retval) > 0)
                    {
                        // Start the table
                        echo "<table>" .
                            "<tr>" .
                            "<th>cdoLogDistance</th>" .
                            "<th>cdoLogDuration</th>" .
                            "<th>cdoLogSpeed</th>" .
                            "<tr>";
                        // Show each row
                        while ($row = mysqli_fetch_assoc($retval))
                        {
                            echo "<tr>" .
                                "<td>" . ($row["cdoLogDistance"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogDuration"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogSpeed"] ?? "NULL") . "</td>" .
                                "</tr>";
                        }
                        // End the table
                        echo "</table>";
                    }
                    // No results
                    else
                    {
                        echo "<p> <em>No results returned.</em> <p>";
                    }

                    // Free result set
                    mysqli_free_result($retval);
                }
                // Form not yet submitted, display the forms
                else
                {
                    // Plans form
                    generate_cardio_form($mysqli, "Plan");

                    // Logs form
                    generate_cardio_form($mysqli, "Log");
                }
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>