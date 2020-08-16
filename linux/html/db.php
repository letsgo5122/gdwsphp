<?php
$dbuser = 'mgdifnkargkimx';
$dbpass = 'ce1782a7310907121c9381457d8e0c90b98195d554824f7487050b3b52cf45b5';
$host = 'ec2-3-215-207-12.compute-1.amazonaws.com';
$dbname='dbm95l24lu9fgo';
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