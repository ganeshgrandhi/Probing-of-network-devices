#!/bin/bash
x=1
while [ $x -le 16 ]
do
  perl backend.pl
  x=$(( $x + 1 ))
done
