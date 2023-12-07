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
  <h2> Trigger Execution </h2>
    <h4> Author: Kaden Barker </h4>
    <p> This page provides an example interface to show that the workoutLog_BEFORE_INSERT trigger
        is working correctly.
    </p>
    <h4 style="display:inline;"> Description: </h4>
    <p style="display:inline;"> The before insert trigger on the workoutLog table enfores that an 
                                athlete will not complete a log for a workout that isn't available
                                on the date entered.
    </p>
    <br/>
    <br/>
    <h4 style="display:inline;"> Justification: </h4>
    <p style="display:inline;"> Workouts are provided over a specific time inorder to produce results.
                                It is important that athletes are only entering logs for workouts that 
                                are availble for that date range.
                            </p>
    <br/>
    <br/>
    <h4 style="display:inline;"> Execution Examples: </h4>
    <p style="display:inline;"> In the real world the athlete would know what workout plan there completing
                                In this representation try creating a workoutLog.
                                Set the the workoutPlan number to 1, and the date to 02-07-2023.
                                After clicking submit you will see that an error occured. This is because the trigger caught
                                that the date entered is out of the range of the workout plan. Now change the completion date
                                to 01-07-2023. As you can see the entry was successfull. </p>



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

$mysqli = mysqli_connect($hostname,$username,$password,$schema);

if ($mysqli->connect_error) {
  die("Database connection failed: " . $mysqli->connect_error);
}

// Turn off autocommit
mysqli_autocommit($mysqli, false);

if(isset($_POST['submit'])) {

  try {
    // using prepare statement to prevent sql injection
    $stmt = $mysqli->prepare("INSERT INTO workoutLog (wrkLogID, wrkPlanID, wrkLogDate)
    VALUES (NULL, ?, ?)")
    or die($mysqli->error);
  
    // getting data from post
    $wrkPlanID=$_POST['wrkPlanID'];
    $wrkLogDate=$_POST['wrkLogDate'];
      
    /* bind PHP variable with SQL parameter */
    $stmt->bind_param('is', $wrkPlanID, $wrkLogDate); // 'is' is for int and string params
  
    // Execute query
    $stmt->execute() or die($stmt->error);
  }
  // insert fails
  catch (mysqli_sql_exception $e){
    echo "<h2> Insert failed: " . $mysqli->error . " </h2>\n";
  }
    // build query
    $getWrkLogTbl = "select * from workoutLog"; // string needs quotes
    // execute query
    $retval = mysqli_query($mysqli, $getWrkLogTbl); 
    // if one or more rows were returned
    if(mysqli_num_rows($retval) > 0){  

      //create table
      echo
      "<table border=\"1\" align=\"center\">
      <tr>
      <td>Workout Log ID </td>
      <td>Workout Plan ID</td>
      <td>Workout Log Date</td>
      </tr>\n";

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

      echo "</table>";
    } else {  
        echo "No results found";  
    }

    // free result set
	  mysqli_free_result($retval);

}
else {

  echo "<p>Please enter the following information for the new Log: </p>";
  // building query
	$query = "SELECT wrkPlanID from workoutPlan order by wrkPlanID";
	// execute query
	$results = $mysqli->query($query);

	// show results
	if ($results->num_rows > 0) {

		echo "<form action=\"insertWrkLog.php\" method=\"POST\">
		<label for=\"wrkPlanID\"> Workout Plan Number: </label>
		<select id=\"wrkPlanID\" name=\"wrkPlanID\" required\n>";

		//getting data for dropdown
		while ($row = mysqli_fetch_assoc($results)) {
			echo "<option value=\"" . $row["wrkPlanID"] . "\">" .  $row["wrkPlanID"] . "</option>\n";
		}
		echo "</select><br><br>";
			
	}
	else {
		echo "<p> No workout Plans in database </p>";
	}

  echo "Completion Date: <input type=\"date\" name=\"wrkLogDate\"><br><br>";
  echo "<input type=\"submit\" value=\"Submit\" name=\"submit\">";
  echo "</form>";
}

// Rollback any changes
mysqli_rollback($mysqli);
// close connection
mysqli_close($mysqli);
?> <!-- signifiies the end of PHP code -->
</body>
  <h4><a href='/~barkerk/insertWrkLog.php'>Create another WorkoutLog</a><h4>
  <h4><a href='/~thompsop1/motion_sense/index.html'>Landing Page</a><h4>
</html>
