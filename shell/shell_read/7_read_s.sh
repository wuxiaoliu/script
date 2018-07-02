#!/bin/bash
# hiding input data from the monitor

read -s -p "Enter your passwd: " pass   #-s 参数使得read读入的字符隐藏
echo
echo "Is your passwd readlly $pass?"
