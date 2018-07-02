#!/bin/bash
# timing the data entry

if read -t 5 -p "Please enter your name: " name     #记得加-p参数， 直接在read命令行指定提示符
then
    echo "Hello $name, welcome to my script"
else
    echo
    echo "Sorry, too slow!"
fi
