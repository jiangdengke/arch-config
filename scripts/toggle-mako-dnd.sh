#!/usr/bin/env bash
# 切换 mako 的勿扰模式，并主动刷新 waybar 状态。
set -euo pipefail

# 未安装 makoctl 时不执行任何操作。
command -v makoctl >/dev/null 2>&1 || exit 0

# 读取当前 mako 模式；读取失败一般意味着 mako 尚未运行。
current_mode="$(makoctl mode 2>/dev/null || true)"
[[ -n "$current_mode" ]] || exit 0

# 根据当前状态切换默认模式与勿扰模式。
if [[ "$current_mode" == *"do-not-disturb"* ]]; then
  makoctl set-mode default >/dev/null 2>&1
  command -v notify-send >/dev/null 2>&1 && notify-send "通知已开启" "mako 已退出勿扰模式。"
else
  makoctl set-mode do-not-disturb >/dev/null 2>&1
fi

# 主动触发一次模块刷新，避免等下一次轮询。
pkill -RTMIN+8 waybar >/dev/null 2>&1 || true
