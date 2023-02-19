#!/usr/bin/env bash

Echo -e "script \n started \t  boss"

a=100
b=200

add=$(($a+$b))
date=$(date +%F)
echo "total  = $add on " + $date

read -p 'enter you name : ' name

echo 'your name is $name'
echo "your name is $name"