#!/bin/bash

# 检查 Rofi 是否正在运行
if pgrep -x rofi > /dev/null
then
    # 如果 Rofi 正在运行,则发送关闭信号
    pkill -x rofi
else
    # 如果 Rofi 没有运行,则启动 Rofi
    rofi -show drun -theme ~/.config/rofi/themes/Arc-Dark.rasi &
fi
