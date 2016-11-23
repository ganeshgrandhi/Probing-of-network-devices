#!/usr/bin/perl -w  
use FindBin '$Bin';

while(1)

{

my $first_run = time();

system("perl $Bin/backend.pl");

my $last_run = time();
my $run_time = $last_run - $first_run;
my $sleep_time=30-$run_time;
sleep ($sleep_time);
}
