<!DOCTYPE html>

<html>
<head> 
<script src='//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

<style>

table
	{
	width:100%;

}
</style>

<script>

$( document ).ready(function() {
console.log( "ready!" );

$('.enabletoggle').click(function(){

	
	id = $(this).attr("id");
    
	//alert(id);
	//$(this).children('.hidden').toggleClass('.hidden');//as-per AndreasAL's suggestion
    $('.'+id).slideToggle( "slow", function() {
		// Animation complete.
		});
});



});

</script>

</head>


<body style="background-color:lightgreen">

<div style="background-color:grey; color:white; padding:20px;">
<h1 style="text-align:center">Assignment 4</h1>
<p title="Assignment 4">

</p>
</div> 

<h2> Click ID for device information <h2>
<h3>List of devices from current database

<right>
<form action = index.php>
<input type = "submit" value="Refresh">
</form>
</right>
</h3>
<?php 

$path = dirname(__FILE__);

$path1 = explode("/",$path,-1);
$path1[count($path1)+1]='db.conf';
$finalpath = implode("/",$path1);

$file = file("$finalpath");
for($i=0;$i<=4;$i++)
	{
		$details=explode('"',$file[$i]);
		$array[$i]="$details[1]";
	}
$host = $array[0];
$port = $array[1];
$database = $array[2];
$username = $array[3];
$password = $array[4];
 

$link = new mysqli($host, $username, $password, $database,$port);

 if (!$link) 
	{
		die('Could not connect: ' . mysql_error());
	}
 echo "Connected successfully \n";


$colours=array("FFFFFF
","FFEEEE
","FFEBEB","FFE5E5","FFE6E6","FFEAEA","FFD6D6","FFCCCC","FFC9C9","FFC1C1","FFBABA","FFB2B2","FFADAD","FFA3A3","FF9999",
"FF8383","FF8080","FF7F7F","FF7575","FF6666","FF5959","FF5959","FF4D4D","FF4C4C","FF4646","FF4545","FF3333","FF3232","FF3030","FF1919"
);




$sql="SELECT * FROM `ASSIGNMENT4`";

$result = $link->query($sql);

echo '<table border="1" style="width:100%">
<tr>
<th>ID</th>
<th>IP Address</th>
<th>Port</th>
<th>Community</th>
<th>Status</th>
</tr>';

while($row = mysqli_fetch_array($result))
{

$k = $row['lostReq']; 
$colour = "#"."$colours[$k]";
if($k >= 30 ){ $colour = "#"."FF0000"; 
}
echo "<tr>";
echo "<td><a href='#' class='enabletoggle' id='".$row['id']."'>" . $row['id'] ."</a><br>
<p class='".$row['id']."' style='display:none;'>"."System Up time: ".$row['sysUp'].
"<br>" ."Sent requests: ".$row		['reqSent']."<br>" ."Missed requests: ".$row['lostReq']."<br>" ."Last Sys up time: ".$row['suTime']."<br>" ."Web Server Time(Last updated at): ".$row['updateTime']."<br>"."Last missed request at : ".$row['lastMissed']."</p></td>"	;
echo "<td>" . $row['ip'] . "</td>";
echo "<td>" . $row['port'] . "</td>";
echo "<td>" . $row['community'] . "</td>";
echo "<td bgcolor=$colour width=50>  </td>";
echo "</tr>";
}
echo "</table>";

?> 
	
	
</table>
</body>
</html>
