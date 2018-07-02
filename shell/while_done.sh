while read LINE
do
    echo $LINE
done < /root/tmp/1.txt
# 这种是从 1.txt 循环读文件
# read命令也有退出状态，当它从文件file中读到内容时，退出状态为0，循环继续惊醒；当read从文件中读完最后一行后，下次便没有内容可读了，此时read的退出状态为非0，所以循环才会退出。


#另一种也很常见的用法：
command | while read line
do
    …
done

#如果你还记得管道的用法，这个结构应该不难理解吧。command命令的输出作为read循环的输入，这种结构长用于处理超过一行的输出，当然awk也很擅长做这种事
