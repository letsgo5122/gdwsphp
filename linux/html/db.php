<?php
$dbuser = 'labxuqgojbd234';
$dbpass = '16171458e5a062b7ec9541a3290626221ec11daeef6c0c2fa96fa1bf5db70234';
$host = 'ec2-35-175-155-248.compute-1.amazonaws.com';
$dbname='dc4hmb1sbma234';
$port="5432";
$dsn = "pgsql:host=$host;port=$port;dbname=$dbname;user=$dbuser;password=$dbpass;sslmode=require";
try{
	$pdo = new PDO($dsn);
	if($pdo){
		//echo "Connected to the $dbname database successfully!";
		;
	}
}catch (PDOException $e){
	// Show error message
	echo $e->getMessage();
}


?>