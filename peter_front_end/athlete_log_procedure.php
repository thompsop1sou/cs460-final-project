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
        <h3> Athlete Log Procedure </h3>
        <!-- Query Results -->
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
                if (isset($_POST["submit"])) {
                    // Label for the results
                    echo "<p>Results for athlete <b>" . $_POST["ath_id"] . "</b> from <b>" . $_POST["start_date"] . "</b> to <b>" . $_POST["end_date"] . "</b>:</p>";

                    // Build query string
                    $sql = "CALL athleteLogProcedure(" . $_POST["ath_id"] . ", '" . $_POST["start_date"] . "', '" . $_POST["end_date"] . "')";
                    // Execute query using the connection created above
                    $retval = mysqli_query($mysqli, $sql);

                    // Display the results
                    if (mysqli_num_rows($retval) > 0) {
                        // Start the table
                        echo "<table>" .
                            "<tr>" .
                            "<th>wrkPlanName</th>" .
                            "<th>wrkLogDate</th>" .
                            "<th>exrName</th>" .
                            "<th>exrType</th>" .
                            "<th>exrLogNotes</th>" .
                            "<th>cdoLogSets</th>" .
                            "<th>cdoLogDistance</th>" .
                            "<th>cdoLogDuration</th>" .
                            "<th>strLogSets</th>" .
                            "<th>strLogReps</th>" .
                            "<th>strLogWeight</th>" .
                            "<tr>";
                        // Show each row
                        while ($row = mysqli_fetch_assoc($retval)) {
                            echo "<tr>" .
                                "<td>" . ($row["wrkPlanName"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["wrkLogDate"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["exrName"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["exrType"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["exrLogNotes"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogSets"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogDistance"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["cdoLogDuration"] ?? "NULL") . "</td>" .
                                "<td>" . ($row["strLogSets"]  ?? "NULL") . "</td>" .
                                "<td>" . ($row["strLogReps"]  ?? "NULL") . "</td>" .
                                "<td>" . ($row["strLogWeight"]  ?? "NULL") . "</td>" .
                                "</tr>";
                        }
                        // End the table
                        echo "</table>";
                    // No results
                    } else {
                        echo "<p> <em>No results returned from procedure.</em> <p>";
                    }

                    // Free result set
                    mysqli_free_result($retval);
                } else {
                    echo "<p> <em>No form data submitted.</em> <p>";
                }
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>