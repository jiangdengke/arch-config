#!/usr/bin/env bash
# 输出 mako 当前状态给 waybar 自定义模块使用。
set -euo pipefail

# 统一输出 JSON，避免在多个分支里重复写 printf。
print_json() {
  local text="$1"
  local class="$2"
  local tooltip="$3"
  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$tooltip"
}

# 没有安装 makoctl 时，直接显示缺失状态。
if ! command -v makoctl >/dev/null 2>&1; then
  print_json " ?" "missing" "mako 未安装"
  exit 0
fi

# 读取当前模式；失败通常意味着 mako 进程未运行。
if ! mode="$(makoctl mode 2>/dev/null | tr '\n' ' ')"; then
  print_json " !" "stopped" "mako 未运行"
  exit 0
fi

# 统计当前通知列表里有多少条记录。
count="$(makoctl list 2>/dev/null | grep -c '^Notification' || true)"
count="${count//[^0-9]/}"
[[ -n "$count" ]] || count=0

# 根据是否开启勿扰与是否有待处理通知决定图标与文案。
if [[ "$mode" == *"do-not-disturb"* ]]; then
  if (( count > 0 )); then
    print_json " $count" "dnd-notification" "勿扰已开启，仍有 $count 条通知积压"
  else
    print_json "" "dnd-none" "勿扰已开启"
  fi
else
  if (( count > 0 )); then
    print_json " $count" "notification" "通知已开启，当前有 $count 条通知"
  else
    print_json "" "none" "通知已开启"
  fi
fi
