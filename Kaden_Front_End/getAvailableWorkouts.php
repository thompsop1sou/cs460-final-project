<!DOCTYPE html>
<html>
<head>

<!-- ************
//
//	CS 460 Fall 2023
//	Created by Kaden Barker
//	Example that will build a table based on input to a procedure
//
************* -->

</head>

<body>
	<h2> Procedure Execution </h2>
    <h4> Author: Kaden Barker </h4>
    <p> This page provides an example interface to show that the availableWorkouts Procedure
        is working correctly.
    </p>
    <h4 style="display:inline;"> Description: </h4>
    <p style="display:inline;"> The available workouts procedure shows all workouts that an
                                athletes trainer has provided based on a given time period.</p>
    <br/>
    <br/>
    <h4 style="display:inline;"> Justification: </h4>
    <p style="display:inline;"> It is common for trainers to provide different workouts for different 
                                days of the week. That being said it is important for an athlete to be 
                                able to view all the workouts for the time that they are searching for.
                            </p>
    <br/>
    <br/>
    <h4 style="display:inline;"> Execution Examples: </h4>
    <p style="display:inline;"> In the real world the athlete would know their
                                ID and be able to search for their workouts. In this representation try searching
                                for an athletes workouts. If you set the ID to 1, the start date to 01-01-2023, and the end
                                date to 02-01-2023. As you can see this will pull up any workouts that are available for athlete
                                1 and in the provided time range. Another example to show that the procedure is working is to set the ID to 1, 
                                the start date to 01-01-2023, and the end date to 01-10-2023. As you will see this now only shows the one 
                                workout for athlete 1 that's in the time frame.</p>


	<p>Please enter the following information for the athlete whose workouts you wish to view: </p>


<?php
// include credientals which should be stored outside your root directory (i.e. outside public_html)
// do NOT use '../' in file path
require_once '/home/SOU/barkerk/dbconfig.php';

// Turn error reporting on
error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
ini_set('display_errors', '1');

// Create connection 
$mysqli = mysqli_connect($hostname,$username,$password,$schema);

// Check connection 
if (mysqli_connect_errno()) {
    printf("Connection failed: " . mysqli_connect_errno());
    exit();
}

// if someone posts data 
if(isset($_POST['submit'])) {

	// using prepare statement to prevent sql injection
	$stmt = $mysqli->prepare("call availableWorkouts(?, ?, ?)")
	  	or die($mysqli->error);
	// get employee name value from post
	$athID=$_POST['athID'];
    $i_startDate=$_POST['i_startDate'];
    $i_endDate=$_POST['i_endDate'];

	/* bind PHP variable with SQL parameter */
	$stmt->bind_param('iss', $athID, $i_startDate, $i_endDate); // 'iss' is for int, string and string params

	// Execute query
	$stmt->execute() or die($stmt->error);
	$retval = $stmt->get_result(); // get result
		
	// if one or more rows were returned
	if(mysqli_num_rows($retval) > 0){  
		// create table
		echo "<table border=\"1\" align=\"center\">
		<tr>
		<td>Workout ID </td>
	    <td>Athlete ID</td>
       	<td>Workout Name</td>
		<td>Workout Start Date</td>
		<td>Workout End Date</td>
		<td>Workout Schedule</td>
		</tr>\n";
		// while there is data to be fetched
		while($row = mysqli_fetch_assoc($retval)) {  
			// access data an build HTML table row
    		echo 
    	 		"
    	  		<tr>
    	  		<td>{$row['wrkPlanID']}</td>  
          		<td>{$row['athID']}</td>
    	  		<td>{$row['wrkPlanName']}</td>
                <td>{$row['wrkPlanStartDate']}</td>
                <td>{$row['wrkPlanEndDate']}</td>
                <td>{$row['wrkPlanSchedule']}</td>
   		  		</tr>\n";  
		} // end while

		echo "</table>\n";
	} else {  
			echo "No results found";  
	}

	// free result set
	mysqli_free_result($retval);

}
else {

	// building query
	$query = "SELECT athID from athlete";
	// execute query
	$results = $mysqli->query($query);

	// show results
	if ($results->num_rows > 0) {

		echo "<form action=\"getAvailableWorkouts.php\" method=\"POST\">
		<label for=\"athID\"> Athlete ID: </label>
		<select id=\"athID\" name=\"athID\" required\n>";

		//getting data for dropdown
		while ($row = mysqli_fetch_assoc($results)) {
			echo "<option value=\"" . $row["athID"] . "\">" .  $row["athID"] . "</option>\n";
		}
		echo "</select><br><br>";
			
	}
	else {
		echo "<p> No athletes in database </p>";
	}

	echo "Start Date: <input type=\"date\" name=\"i_startDate\"><br><br>";
	echo "End Date: <input type=\"date\" name=\"i_endDate\"><br><br>";
	echo "<input type=\"submit\" value=\"Submit\" name=\"submit\">";
}

//close connection
mysqli_close($mysqli); 
?> <!-- signifiies the end of PHP code -->
</body>

<h4><a href="/~thompsop1/motion_sense/index.html">Landing Page</a></h4>
</html>