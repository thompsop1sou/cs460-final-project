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
<h2> Function Execution </h2>
    <h4> Author: Kaden Barker </h4>
    <p> This page provides an example interface to show that the exerciseProgress function
        is working correctly.
    </p>
    <h4 style="display:inline;"> Description: </h4>
    <p style="display:inline;"> The exerciseProgress fuction is designed so that an athlete or trainer can
                                search an exercise and see the progress that was made from their first time logging 
                                the exercise to their last time.
    </p>
    <br/>
    <br/>
    <h4 style="display:inline;"> Justification: </h4>
    <p style="display:inline;"> Athletes work with trainers to improve them selves or recover from injury. This is why it
                                is important to have a way of seeing progress. If a trainer isn't seeing enough progress in their 
                                athlete then the trainer knows that something isn't working. Similarly if an athlete isn't seeing 
                                progress then they know that they may need to find a differnent trainer. That being said this function 
                                returns progress for one exercise, however it could also be used in a procedure to generate a progress 
                                report for everything an athlete does.
                            </p>
    <br/>
    <br/>
    <h4 style="display:inline;"> Execution Examples: </h4>
    <p style="display:inline;"> An athlete that uses this system will know there Athlete ID just as most students know their student ID. They will 
                                also know what exercises they have been doing. That being said try entering 1 for the Athlete ID and squat for the 
                                Exercise Name. You will see that athlete 1 has increased by 10 since they started working with their trainer.
                                Now try entering deadlift for the Exercise Name. You can now see that athlete 1 hasn't improved their deadlift yet.</p>



	<p>Please enter the following information to see your progress: </p>



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
	$stmt = $mysqli->prepare("select exerciseProgress(?, ?) as progress")
	  	or die($mysqli->error);

	// get data value from post
	$athID=$_POST['athID'];
    $i_exrName=$_POST['exrName'];

	/* bind PHP variable with SQL parameter */
	$stmt->bind_param('is', $athID, $i_exrName); // 'is' is for int and string params

	// Execute query
	$stmt->execute() or die($stmt->error);
	$retval = $stmt->get_result(); // get result

	
	// if one or more rows were returned
	if(mysqli_num_rows($retval) > 0){  
		// create table
		echo 
		"<table border=\"1\" align=\"center\">
		<tr> 
		<td>Exercise Progress </td>
	    </tr>\n";

		// while there is data to be fetched
		while($row = $retval->fetch_assoc()) {  
			// access data an build HTML table row
    		echo 
    	 		"
    	  		<tr> 
    	  		<td>{$row['progress']}</td>  
   		  		</tr>\n";  
		} // end while

		echo "</table>\n";
	} else {  
			echo "No results found";  
	}
	// free result set
	mysqli_free_result($retval);
}
else { // nothing submitted yet

	// building query
	$query = "SELECT athID from athlete";
	// execute query
	$results = $mysqli->query($query);

	// show results
	if ($results->num_rows > 0) {

		echo "<form action=\"exerciseProgress.php\" method=\"POST\">
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
	
	echo "Exercise Name: <input type=\"text\" name=\"exrName\"><br><br>";
	echo "<input type=\"submit\" name=\"submit\" value=\"Submit\">";
	echo "</form>";
}
//close connection
mysqli_close($mysqli); 
?> <!-- signifiies the end of PHP code -->
</body>
	<h4><a href="/~thompsop1/motion_sense/index.html">Landing Page</a></h4>
	<h4><a href="/~barkerk/exerciseProgress.php">Check Another Exercise</a></h4>
</html>