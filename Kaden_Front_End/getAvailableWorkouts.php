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

<table border="1" align="center">
<tr>

  <td>Workout ID </td>
  <td>Athlete ID</td>
  <td>Workout Name</td>
  <td>Workout Start Date</td>
  <td>Workout End Date</td>
  <td>Workout Schedule</td>
</tr>

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
	} else {  
			echo "No results found";  
	}
}
// free result set
mysqli_free_result($retval);
//close connection
mysqli_close($mysqli); 
?> <!-- signifiies the end of PHP code -->
</body>

<h4><a href="/~thompsop1/motion_sense/index.html">Landing Page</a></h4>
</html>