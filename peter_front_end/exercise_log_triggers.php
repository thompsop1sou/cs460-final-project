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
        <h3> Exercise Log Triggers </h3>
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
                // Turn off autocommit
                mysqli_autocommit($mysqli, false);

                // The invalid insert scenario was selected
                if (isset($_POST["invalid_insert"])) {
                    try {
                        // Create new entry in workoutLog table
                        $sql = "INSERT INTO workoutLog VALUES (100, 4, '2023-04-08')";
                        mysqli_query($mysqli, $sql);
                        // Attempt to create new entry in exerciseLog table
                        $sql = "INSERT INTO exerciseLog VALUES (100, 7, 100, 'test log')";
                        mysqli_query($mysqli, $sql);
                        // If no error, indicate success
                        echo "<p> Success! </p>";
                    } catch (mysqli_sql_exception $e) {
                        echo "<p> There was an error: " . mysqli_error($mysqli) . " </p>";
                    }
                // The valid insert scenario was selected
                } elseif (isset($_POST["valid_insert"])) {
                    try {
                        // Create new entry in workoutLog table
                        $sql = "INSERT INTO workoutLog VALUES (100, 4, '2023-04-08')";
                        mysqli_query($mysqli, $sql);
                        // Attempt to create new entry in exerciseLog table
                        $sql = "INSERT INTO exerciseLog VALUES (100, 10, 100, 'test log')";
                        mysqli_query($mysqli, $sql);
                        // If no error, indicate success
                        echo "<p> Success! </p>";
                    } catch (mysqli_sql_exception $e) {
                        echo "<p> There was an error: " . mysqli_error($mysqli) . " </p>";
                    }
                // The invalid update scenario was selected
                } elseif (isset($_POST["invalid_update"])) {
                    try {
                        // Attempt to update an entry in exerciseLog table
                        $sql = "UPDATE exerciseLog SET exrPlanID = 7 WHERE exrLogID = 18";
                        mysqli_query($mysqli, $sql);
                        // If no error, indicate success
                        echo "<p> Success! </p>";
                    } catch (mysqli_sql_exception $e) {
                        echo "<p> There was an error: " . mysqli_error($mysqli) . " </p>";
                    }
                // No form data
                } else {
                    echo "<p> <em>No form data submitted.</em> <p>";
                }

                // Rollback any changes
                mysqli_rollback($mysqli);
            }

            // Close connection
            mysqli_close($mysqli);
        ?>
    </body>
</html>