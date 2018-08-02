#!/bin/bash
# demo1：当给程序输入start|s时，显示service is running!;stop——>service is stoped;...
read -p "Please input process action : (start|s|stop)" var
case $var in
    start|s)
    echo service is running
    ;;
    stop)
    echo service is stoped
    ;;
    reload)
    echo service is reload
    ;;
    *)
    echo error parameters !
    ;;
esac
