<?php
$dbuser = 'qhoyaptumhoasp';
$dbpass = 'fad670be17d4f0b28212847361b5dedfb077bc2eab0cb7b4187e6b9bbcf96459';
$host = 'ec2-34-195-115-225.compute-1.amazonaws.com';
$dbname='d7v88kdeqoha1n';
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