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
        <h3> Cardio Speed Functions </h3>
        <!-- Query Results -->
        <?php
            // Credientials
            require_once "/home/SOU/thompsop1/dbconfig.php";

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
                    echo "<p>Results for cardio <b>" . strtolower($_POST["trgt_table"]) . "</b> with ID <b>" . $_POST["cdo_id"] . "</b>:</p>";

                    // Looking at cardio plans
                    if ($_POST["trgt_table"] == "Plan") {
                        // Build query string
                        $sql = "SELECT cdoPlanDistance, cdoPlanDuration, cardioPlanSpeedFunction(exrPlanID) AS cdoPlanSpeed FROM cardioPlan WHERE exrPlanID=" . $_POST["cdo_id"];
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
                    // Looking at cardio logs
                    } elseif ($_POST["trgt_table"] == "Log") {
                        // Build query string
                        $sql = "SELECT cdoLogDistance, cdoLogDuration, cardioLogSpeedFunction(exrLogID) AS cdoLogSpeed FROM cardioLog WHERE exrLogID=" . $_POST["cdo_id"];
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
                    // Invalid
                    } else {
                        echo "<p> <em>Invalid function type.</em> <p>";
                    }
                } else {
                    echo "<p> <em>No form data submitted.</em> <p>";
                }
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>