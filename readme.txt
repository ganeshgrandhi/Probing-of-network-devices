#################################################################################################

																	ASSIGNMENT -4 

#################################################################################################

*****Prerequisites:

Properly installed and required configurations

			mysql-server
			apache2
			snmpd
			snmp
			php5

*****Required permissions must be enabled 

The webserver you are using should have read and write permissions to the directory of the script and to the assignmnets directories.

snmp and http permissions should be enabled on the device/server you are monitoring.

*****Installation of required modules:								

The following components need to be installed. 

sudo apt-get install libdbi-perl
sudo apt-get install libsnmp-perl 
sudo apt-get install libnet-snmp-perl
perl -MCPAN -e 'install Net::SNMP'
perl -MCPAN -e 'install DBD::MySQL'

*****Instructions:

1. The backend script can be run on the terminal using

					perl <path to folder>/backend.pl
					
		The backend1.pl script must be run in the terminal, and probes the devices from the table `DEVICES` in the users' database.			

2. Wait for atleast 20 to 30 seconds  for values to get updated.

3. From your browser go to the folder assignment4.

4. The list of  devices which are curently being monitored is displayed.

5. Click on the "id" of the device to see the details

6. Device status is color coded with white representing system is responding. And shades of red represting missed request based on number of missed requests. 30 missed requests is the threshold represented by complete RED colour. 

7. Backend.sh script is written for running the perl script for 16 iterations.

