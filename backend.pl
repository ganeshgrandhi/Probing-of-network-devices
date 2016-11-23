#! /usr/bin/perl
#use strict;
use warnings;
use v5.10;
use DBI;
use DBD::mysql;
use Net::SNMP;
use Cwd;

my $dir = cwd;
my $dir1=$dir;
my $dir2= substr $dir1, 0, -11;
my $dir3="$dir2"."db.conf";

open (F4, "$dir3") || die "Can't open $dir3: $!";

my @lines = <F4>;
my @host = split('"', $lines[0]);
my @port = split('"', $lines[1]);
my @database = split('"', $lines[2]);
my @username = split('"', $lines[3]);
my @password = split('"', $lines[4]);
my $database=$database[1];
my $host=$host[1];
my $port=$port[1];
my $username=$username[1];
my $password=$password[1];
$dbh = DBI->connect("DBI:mysql:$database;$host;$port",$username,$password)
 or die "Connection Error: $DBI::errstr\n";
 
 
 $dev = "select * from DEVICES";
 $sth = $dbh->prepare($dev);
 $sth->execute
 or die "SQL Error: $DBI::errstr\n";

### The process starts here ###

#Fetching the credentials from the mySQL DB 

while (@row = $sth->fetchrow_array) 
{

			#Getting the credentials for each device from the database
				for ( $k=0;$k<=3;$k++)
					{
					 my @values=split(' ',$row[$k]);
					 foreach my $val (@values)
						{
							$credentials[$k]=$val;
						}
					}
			
$id = $credentials[0];
$ip = $credentials[1];
$port = $credentials[2];
$community = $credentials[3];

#Polling of data using SNMP
  
		$session = Net::SNMP->session( -hostname => $ip, -port => $port, -community => $community, Nonblocking=>'1');

			$oid    = "1.3.6.1.2.1.1.3.0";      
			$result = $session->get_request(-varbindlist => [ $oid ],-callback => [ \&get_callback, "$id", "$ip","$port","$community"]);

}

snmp_dispatcher();
$result=$session->close();

#polls device for system up time
sub get_callback
   
{
      
       ($session,$id,$ip,$port,$community) = @_;
		    
		    
		    my $oid    = "1.3.6.1.2.1.1.3.0";
		    my $response = $session->var_bind_list($oid);
		    if (!defined $response) 
											{ 
													responsefail($session,$id,$ip,$port,$community);
											 }   
				else
				
				{
				
				$sysUp = $response->{$oid};
				
				$updateTime = localtime();
					
					 			$dev1 =		"CREATE TABLE IF NOT EXISTS `ASSIGNMENT4` (
 														 `id` int(10) NOT NULL,
 														 `ip` varchar(40) NOT NULL,
															`port` varchar(40) NOT NULL,
															`community` varchar(40) NOT NULL,
															`reqSent` int(25) NOT NULL,
															`lostReq` int(25) NOT NULL,
															`sysUp` varchar(40) NOT NULL,
															`suTime` varchar(40) NOT NULL,
															`updateTime` varchar(40) NOT NULL,
															`lastMissed` varchar(40) NOT NULL,
															PRIMARY KEY (`id`)
														) ENGINE=InnoDB DEFAULT CHARSET=latin1;";
					
								$sth1 = $dbh->prepare($dev1);
								$sth1->execute;
					
					#Insert into table
					
					$check = $dbh->prepare("SELECT * FROM  `ASSIGNMENT4` WHERE `id` = '$id'");
					$check->execute;
					my @row = $check->fetchrow_array();
									
					if($row[0])
					
						{ 
							if($row[1] eq "$ip" && $row[2] eq "$port" && $row[3] eq "$community")
								{
										 $req=$row[4]+1;
								$updateExist = $dbh->prepare("UPDATE `ASSIGNMENT4` SET `reqSent`='$req',`lostReq`='0',
												`sysUp`='$sysUp',`suTime`='$updateTime',`updateTime`='$updateTime' WHERE `id` = '$row[0]'");
								$updateExist->execute;
										
													                              					
								}else{
								
								$updateModify = $dbh->prepare("UPDATE `ASSIGNMENT4` SET `ip`='$ip',
									`port`='$port',`community`='$community',`reqSent`='1',`lostReq`='0',
									`sysUp`='$sysUp',`suTime`='$updateTime',`updateTime`='$updateTime' WHERE `id` = '$row[0]'");
								$updateModify->execute;
										
								}	
									
						}else{
							
							$insert = $dbh->prepare("INSERT INTO `ASSIGNMENT4`(`id`, `ip`, `port`, `community`, `reqSent`, `lostReq`,
							 `sysUp`, `suTime`, `updateTime`) VALUES ('$id','$ip','$port','$community','1','0','$sysUp','$updateTime','$updateTime')");
							$insert->execute;			
					}
				return 0;		
			}
return 0;
}	


#Routine if device doesnt respond
sub responsefail
{

($session,$id,$ip,$port,$community) = @_;

$updateTime = localtime();
			

		$dev2 =		"CREATE TABLE IF NOT EXISTS `ASSIGNMENT4`( 
							 `id` int(255) NOT NULL,
 							 `ip` varchar(40) NOT NULL,
								`port` varchar(40) NOT NULL,
	  						`community` varchar(40) NOT NULL,
			  				`reqSent` int(25) NOT NULL,
		 		  			`lostReq` int(25) NOT NULL,
								`sysUp` varchar(40) NOT NULL,
					  		`suTime` varchar(40) NOT NULL,
								`updateTime` varchar(40) NOT NULL,
								`lastMissed` varchar(40) NOT NULL,	
								PRIMARY KEY (`id`)
								) ENGINE=InnoDB DEFAULT CHARSET=latin1;";
					
								$sth2 = $dbh->prepare($dev2);
								$sth2->execute;
					
#Insert into table
					
	$check = $dbh->prepare("SELECT * FROM  `ASSIGNMENT4` WHERE `id` = '$id'");
	$check->execute;
	my @row = $check->fetchrow_array();
						
	if($row[0])
					
		{
				if($row[1] eq "$ip" && $row[2] eq "$port" && $row[3] eq "$community")
					{ 
							$reqL=$row[4]+1; 
							$lost=$row[5]+1; 
							$updateExist1 = $dbh->prepare("UPDATE `ASSIGNMENT4` SET `reqSent`='$reqL',
												`lostReq`='$lost',`updateTime`='$updateTime',`lastMissed`='$updateTime' WHERE `id` = '$row[0]'");
							$updateExist1->execute;
							
  				}else{ 
								
							$updateModify1 = $dbh->prepare("UPDATE `ASSIGNMENT4` SET `ip`='$ip',
							`port`='$port',`community`='$community',`reqSent`='1',`lostReq`='1',`updateTime`='$updateTime',`lastMissed`='$updateTime' WHERE `id` = '$row[0]'");
							$updateModify1->execute;
										
					}	
									
					}else{
							 
							
				$insert1 = $dbh->prepare("INSERT INTO `ASSIGNMENT4`(`id`, `ip`, `port`, `community`, `reqSent`, `lostReq`,
							 `updateTime`,`lastMissed`) VALUES ('$id','$ip','$port','$community','1','1','$updateTime','$updateTime')");
				$insert1->execute;			
					}

								
return 0 ;
}

