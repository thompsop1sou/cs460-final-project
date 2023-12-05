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

  <td>Exercise Progress </td>
</tr>

<h4><a href="/~thompsop1/motion_sense/index.html">Landing Page</a></h4>
<h4><a href="/~barkerk/exerciseProgress.html">Check Another Exercise</a></h4>

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
		// while there is data to be fetched
		while($row = mysqli_fetch_assoc($retval)) {  
			// access data an build HTML table row
    		echo 
    	 		"
    	  		<tr> 
    	  		<td>{$row['progress']}</td>  
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