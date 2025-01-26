#!/bin/bash

set -x

# 壁纸存放目录
WALLPAPER_DIR="/home/jdk/Pictures/wallpapers"

# 日志文件路径
LOGFILE="/home/jdk/.config/hypr/scripts/wallpaper_change.log"

# 文件存储上一次使用的壁纸索引
PREV_INDEX_FILE="/home/jdk/.config/hypr/scripts/prev_wallpaper_index.txt"

# 确保日志目录存在
mkdir -p "$(dirname "$LOGFILE")"

# 开启调试模式，将所有输出追加到日志文件
exec >> "$LOGFILE" 2>&1
echo "----------------------------------------"
echo "脚本启动于: $(date '+%Y-%m-%d %H:%M:%S')"

# 防止脚本被多次启动
SCRIPT_NAME=$(basename "$0")
if pgrep -f "$SCRIPT_NAME" | grep -v $$ > /dev/null; then
    echo "另一个实例的脚本正在运行，退出当前脚本。"
    exit 0
fi

# 读取上一次使用的壁纸索引
if [ -f "$PREV_INDEX_FILE" ]; then
    PREV_INDEX=$(cat "$PREV_INDEX_FILE")
    echo "上一次使用的壁纸索引: $PREV_INDEX"
    # 验证索引是否为数字
    if ! [[ "$PREV_INDEX" =~ ^[0-9]+$ ]]; then
        echo "无效的索引，重置为 -1。"
        PREV_INDEX=-1
    fi
else
    PREV_INDEX=-1
    echo "没有找到上一次使用的壁纸索引记录。"
fi

# 无限循环
while true; do
    echo "开始重新索引壁纸目录..."

    # 获取所有支持的图片文件，按名称排序
    WALLPAPER_LIST=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.bmp" -o -iname "*.gif" \) | sort))

    # 获取壁纸总数
    TOTAL_WALLPAPERS=${#WALLPAPER_LIST[@]}
    echo "检测到 $TOTAL_WALLPAPERS 张壁纸。"

    if [ "$TOTAL_WALLPAPERS" -eq 0 ]; then
        echo "错误: 没有找到任何壁纸。等待300秒后重试。"
        sleep 300
        continue
    fi

    # 验证 PREV_INDEX 是否在新的壁纸列表范围内
    if [ "$PREV_INDEX" -ge "$TOTAL_WALLPAPERS" ]; then
        echo "之前的索引超出当前壁纸数量，重置为 -1。"
        PREV_INDEX=-1
    fi

    # 计算下一个壁纸的索引
    NEXT_INDEX=$(( (PREV_INDEX + 1) % TOTAL_WALLPAPERS ))
    WALLPAPER="${WALLPAPER_LIST[$NEXT_INDEX]}"
    echo "选中的壁纸索引: $NEXT_INDEX，路径: $WALLPAPER"

    # 检查选中的壁纸是否存在
    if [ ! -f "$WALLPAPER" ]; then
        echo "错误: 壁纸文件不存在: $WALLPAPER"
        # 移除无效的壁纸并重试
        unset 'WALLPAPER_LIST[$NEXT_INDEX]'
        TOTAL_WALLPAPERS=${#WALLPAPER_LIST[@]}
        if [ "$TOTAL_WALLPAPERS" -eq 0 ]; then
            echo "错误: 没有有效的壁纸文件。等待300秒后重试。"
            sleep 300
            continue
        fi
        PREV_INDEX=$NEXT_INDEX
        continue
    fi

    # 设置壁纸
    echo "正在设置壁纸: $WALLPAPER"
    swww img "$WALLPAPER"
    if [ $? -eq 0 ]; then
        echo "壁纸设置成功。"
    else
        echo "错误: 设置壁纸失败。"
    fi

    # 记录日志
    echo "$(date '+%Y-%m-%d %H:%M:%S') 更换壁纸: $WALLPAPER"

    # 保存当前壁纸索引
    echo "$NEXT_INDEX" > "$PREV_INDEX_FILE"
    echo "当前壁纸索引已保存。"

    # 更新 PREV_INDEX 以准备下次循环
    PREV_INDEX=$NEXT_INDEX

    # 等待五分钟
    echo "等待300秒（5分钟）后再次更换壁纸。"
    sleep 300
done
