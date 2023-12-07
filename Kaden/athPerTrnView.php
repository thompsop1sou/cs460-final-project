<!DOCTYPE html>
<html>
<head>
</head>

<body>

<h2> View Execution </h2>
<h4> Author: Kaden Barker </h4>
<p> This page provides an example interface to show that the athPerTrn View has been created properly.</p>
<h4 style="display:inline;"> Description: </h4>
<p style="display:inline;"> This view is designed to show all trainers that exist in the database
                            and the number of athletes that are currently active.</p>
<br/>
<br/>
<h4 style="display:inline;"> Justification: </h4>
<p style="display:inline;"> From a business perspective it is important that trainers workload is spread
                        it wouldn't make sense to have one trainer working with 10 people and another working wiht 
                        2 people, when both trainers are capable of doing the same job.
</p>
<br/>
<br/>

<table border="1" align="center">
<tr>

  <td>Trainer ID </td>
  <td>First Name</td>
  <td>Last Name</td>
  <td>Number of Athletes</td>
</tr>
<h4><a href="/~thompsop1/motion_sense/index.html">Landing Page</a></h4>

<?php
/************
//
//	CS 460 Fall 2021
//	Created by Kaden Barker
//	accessing a view from the motion sense database
//
*************/

// credientials
require_once '/home/SOU/barkerk/dbconfig.php';

// Turn error reporting on
error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
ini_set('display_errors', '1');

// Create connection using procedural interface
$mysqli = mysqli_connect($hostname,$username,$password,$schema);

// Check connection (and exit if it fails)
if (mysqli_connect_errno()) {
    printf("Connection failed: " . mysqli_connect_errno());
    exit();
}


// build query string using prepare
$stmt = $mysqli->prepare('select * from athPerTrn')
	  	or die($mysqli->error);   

/* execute the prepared statement */
$stmt->execute() or die($mysqli->error);
	
/* get result set */
$retval = $stmt->get_result();

// if more than 0 rows were returned fetch each row and echo values of interest
if(mysqli_num_rows($retval) > 0){  
    while($row = mysqli_fetch_assoc($retval)){  
    echo 
        "
        <tr>
        <td>{$row['ID']}</td>  
        <td>{$row['FirstName']}</td>
        <td>{$row['LastName']}</td>
        <td>{$row['NumberofAthletes']}</td>
        
        </tr>\n";  
    } 
}else{  
	echo "No results found";  
}  

// free result set
mysqli_free_result($retval);
//close connection
mysqli_close($mysqli); 

?> 
</body>
</html>