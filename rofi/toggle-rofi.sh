#!/usr/bin/env bash

# 日志记录
LOG_FILE="$HOME/rofi-launch.log"
echo "$(date '+%Y-%m-%d %H:%M:%S'): Launching Rofi" >>"$LOG_FILE"

# 主题路径
THEME_PATH="$HOME/.config/rofi/rofi-theme.rasi"

# 如果 Rofi 已经在运行，则关闭它
if pgrep -x rofi >/dev/null 2>&1; then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): Rofi already running, terminating" >>"$LOG_FILE"
  pkill -x rofi
  exit 0
fi

# 启动 Rofi
if [ -f "$THEME_PATH" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): Using custom theme" >>"$LOG_FILE"
  exec rofi -show drun -theme "$THEME_PATH"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S'): Theme not found, using default" >>"$LOG_FILE"
  exec rofi -show drun
fi
