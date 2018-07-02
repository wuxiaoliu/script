#!/bin/bash
# testing the REPLY environment variable
read -p "Enter a number: "
factorial=1
for (( count=1; count<= $REPLY; count++ ))
do
   factorial=$[ $factorial * $count ]   #等号两端不要有空格
done
echo "The factorial of $REPLY is $factorial"
