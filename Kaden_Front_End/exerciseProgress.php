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
	// get employee id value from post
	$athID=$_POST['athID'];
    $i_exrName=$_POST['exrName'];
	// build query
  	$query = "select exerciseProgress($athID, '$i_exrName') as progress";; // string needs quotes
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