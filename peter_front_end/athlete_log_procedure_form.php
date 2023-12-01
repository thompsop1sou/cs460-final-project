<!doctype HTML>
<html>
    <head>
        <meta charset="UTF-8" />
        <title> Motion Sense - Athlete Log Procedure </title>
        <link rel="stylesheet" href="basic_style.css">
    </head>
    <body>
        <!-- Database project title -->
        <h1> <a href="index.html">Motion Sense</a> </h1>
        <!-- Page Title -->
        <h3> <a href="athlete_log_procedure_form.php">Athlete Log Procedure</a> </h3>
        <!-- Author -->
        <p>
            <b>Author:</b> Peter Thompson
        </p>
        <!-- Description -->
        <p>
            <b>Description:</b> This procedure returns a result set containing all of the logs for
            a particular athlete during a particular date range.
        </p>
        <!-- Justification -->
        <p>
            <b>Justification:</b> This procedure could be used by trainers who want to see a report
            of what an athlete has done during the past week (or some other time period).
        </p>
        <!-- Expected Execution -->
        <p>
            <b>Expected Execution:</b> Inputs to the procedure include the ID of the athlete, a
            start date, and an end date. The procedure will return a table that includes all logs
            for the selected athlete over the indicated date range. Some valid inputs include:
        </p>
        <ul>
            <li>
                Athlete <b>Andrea Adams</b> from <b>2023-01-01</b> to <b>2023-01-04</b>.
                <ul>
                    <li>
                        This should return two rows, each of which is for a workout called "Run".
                    </li>
                    <li>
                        Extending the end date to <b>2023-01-19</b> should return nine rows. Three of
                        these rows are for a workout called "Run". The other six rows are for a
                        workout called "Lower Body Power".
                    </li>
                </ul>
            </li>
            <li>
                Athlete <b>Aaron Anderson</b> from <b>2023-02-02</b> to <b>2023-02-02</b>.
                <ul>
                    <li>
                        This should return four rows, each of which is for a workout called
                        "Bodyweight Workout".
                    </li>
                    <li>
                        Extending the end date to <b>2023-02-06</b> should return eight rows. Each of
                        these rows is for a workout called "Bodyweight Workout".
                    </li>
                </ul>
            </li>
        </ul>
        <!-- Form -->
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
                $sql = "SELECT athID, athFirstName, athLastName FROM athlete";
                // Execute query using the connection created above
                $retval = mysqli_query($mysqli, $sql);

                // No results
                if (!(mysqli_num_rows($retval) > 0)) {
                    echo "<p><em>No athletes found in database.</em></p>\n";
                // Some results
                } else {
                    // Start of the form
                    echo "
        <form action=\"athlete_log_procedure_results.php\" method=\"post\">
            <p>
                <label for=\"ath_id\"> Athlete: </label>
                <select id=\"ath_id\" name=\"ath_id\" required>";

                    // Add each athlete to the select field
                    while ($row = mysqli_fetch_assoc($retval)) {
                        echo "
                    <option value=\"" . $row["athID"] . "\">" . $row["athFirstName"] . " " . $row["athLastName"] . " (ID " . $row["athID"] . ")</option>";
                    }

                    // End of the form
                    echo "
                </select>
            </p>
            <p>
                <label for=\"start_date\"> Start Date: </label>
                <input type=\"date\" id=\"start_date\" name=\"start_date\" value=\"2023-01-01\" required>
            </p>
            <p>
                <label for=\"end_date\"> End Date: </label>
                <input type=\"date\" id=\"end_date\" name=\"end_date\" value=\"2023-01-01\" required>
            </p>
            <p>
                <input type=\"submit\" name=\"submit\" value=\"Submit\">
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