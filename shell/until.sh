#!/bin/bash
# Program
# This is a test file

#这里定义变量时，中间不能有空格
num=10

#util循环，当num <= 5时(这里注意，【】中的任意一个变量都必须以空格分开，否则会报错)，终止循环，否则一直循环下去
until [ $num -le 5 ];
do
#输出当前num的值
echo $num
#把num的值减一，这里也可以替换为((num--))达到相同的效果
let num--

#本次循环结束
done;
