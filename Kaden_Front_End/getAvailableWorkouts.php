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

<h4><a href="/~barkerk/landingPage.html">Landing Page</a></h4>

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
echo "Connected successfully  <br>  <br>";

// if someone posts data 
if(isset($_POST['submit'])) {
	// get employee name value from post
	$athID=$_POST['athID'];
    $i_startDate=$_POST['i_startDate'];
    $i_endDate=$_POST['i_endDate'];
	// build query
  	$query = "call availableWorkouts($athID, '$i_startDate', '$i_endDate')"; // string needs quotes
  	// execute query
  	$retval = mysqli_query($mysqli, $query); 
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
</html>