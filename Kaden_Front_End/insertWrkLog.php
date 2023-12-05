<!DOCTYPE html>
<html>
<head>

<!-- ************
//
//	CS 460 Fall 2023
//	Created by Kaden Barker
//	Example that will build a table showing trigger results
//
************* -->

</head>

<body>

<table border="1" align="center">
<tr>

  <td>Workout Log ID </td>
  <td>Workout Plan ID</td>
  <td>Workout Log Date</td>
</tr>


<?php // signifies the start of PHP code
/************
//
//	CS 460 Fall 2023
//	Created by Kaden Barker
//	Inserting data via post request, and testing trigger
//
*************/


require_once '/home/SOU/barkerk/dbconfig.php';

// Turn error report on
error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
ini_set('display_errors', '1');

$dbconnect = mysqli_connect($hostname,$username,$password,$schema);

if ($dbconnect->connect_error) {
  die("Database connection failed: " . $dbconnect->connect_error);
}

// Turn off autocommit
mysqli_autocommit($dbconnect, false);

if(isset($_POST['submit'])) {
    // using prepare statement to prevent sql injection
    $stmt = $dbconnect->prepare("INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate)
    VALUES (NULL, ?, ?)")
    or die($dbconnect->error);
  
    // getting data from post
    $wrkPlanID=$_POST['wrkPlanID'];
    $wrkLogDate=$_POST['wrkLogDate'];
      
    /* bind PHP variable with SQL parameter */
    $stmt->bind_param('is', $wrkPlanID, $wrkLogDate); // 'is' is for int and string params
  
    // Execute query
    $stmt->execute() or die($stmt->error);

    // build query
    $getWrkLogTbl = "select * from workoutLog"; // string needs quotes
    // execute query
    $retval = mysqli_query($dbconnect, $getWrkLogTbl); 
    // if one or more rows were returned
    if(mysqli_num_rows($retval) > 0){  
      // while there is data to be fetched
      while($row = mysqli_fetch_assoc($retval)) {  
        // access data an build HTML table row
          echo 
            "
              <tr>
                <td>{$row['wrkLogID']}</td>  
                <td>{$row['wrkPlanID']}</td>
                <td>{$row['wrkLogDate']}</td>
    
              </tr>\n";  
      } // end while
    } else {  
        echo "No results found";  
    }

    echo "<h4><a href='/~barkerk/newWrkLog.html'>Create another WorkoutLog</a><h4>";
    echo "<h4><a href='/~thompsop1/motion_sense/index.html'>Landing Page</a><h4>";

}

// Rollback any changes
mysqli_rollback($dbconnect);
// close connection
mysqli_close($dbconnect);
?> <!-- signifiies the end of PHP code -->
