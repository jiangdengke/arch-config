#!/usr/bin/env bash

# 获取 mako 模式和通知数量
mode=$(makoctl mode 2>/dev/null || echo "default")
# 统计 "Notification" 开头的行数
count=$(makoctl list 2>/dev/null | grep -c "^Notification" 2>/dev/null || echo "0")
# 确保 count 是纯数字
count=$(echo "$count" | tr -d '\n' | grep -o '[0-9]*' | head -1)
[ -z "$count" ] && count=0

# 根据模式和通知数量决定图标状态
if [[ "$mode" == *"dnd"* ]]; then
    if [ "$count" -gt 0 ]; then
        class="dnd-notification"
    else
        class="dnd-none"
    fi
else
    if [ "$count" -gt 0 ]; then
        class="notification"
    else
        class="none"
    fi
fi

# 输出 JSON 格式
if [ "$count" -gt 0 ]; then
    text=" $count"
else
    text=""
fi

printf '{"text":"%s","class":"%s"}\n' "$text" "$class"
