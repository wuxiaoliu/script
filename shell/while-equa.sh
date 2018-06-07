#!/bin/bash
# Program
# This is a test file

#这里定义变量时，中间不能有空格
num=10

#while循环，当num >= 5时，一直循环下去
while(($num >= 5));do
#输出当前num的值
echo $num
#把num的值减一，这里也可以替换为((num--))达到相同的效果
let num--

#本次循环结束
done;
