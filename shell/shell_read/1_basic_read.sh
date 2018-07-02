#!/bin/bash
#testing the read command

echo -n "Enter you name:"   #echo -n 让用户直接在后面输入
read name  #输入的多个文本将保存在一个变量中
echo "Hello $name, welcome to my program."
