#!/bin/bash
# demo2:相互嵌套
read -p "小明，你喜欢我吗？（喜欢|不喜欢|爱你）:" love
case $love in
    喜欢)
    echo "我也喜欢你"
    ;;
    不喜欢)
    read -p "那你喜欢谁？" who
    case $who in
        小红)
        echo "她是我的闺蜜"
        ;;
        小彭)
        echo "额..拜拜"
        ;;
        *)
        echo "我们不合适"
        ;;
    esac
    ;;
    *)
    echo "你到底什么意思？"
    ;;
esac
