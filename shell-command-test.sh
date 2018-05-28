#!/bin/bash
# 执行命令，将命令的结果作为变量，并且遍历这些变量
for file in `ls`
do
echo "This directory has ${file} file."
done

mystring="mystring---!"
echo ${#mystring}

# 对变量做计算输出
number=(189hugu 2 3 4 5 inj9)
echo ${number[@]}
echo ${#number}
echo ${#number[@]}
echo ${number[@]/inj9/98}


# shell 常用的变量
echo "---------------------------------------------------------------"
echo "file name: $0"
echo "first parameter: $1"
echo "second parameter: $2"
echo "parameter number: $#"
echo "all parameter: $*"
echo "script pid: $$"
echo "backend pid : $!"
echo "xuanxiang: $-"
echo "status: $?"

# 变量所有的变量
echo "========================"
for i in "$*"; do
    echo $i
done

for i in "$@"; do
    echo $i
done


# shell 做计算
val=`expr 2 + 2`
echo "sum:$val"
