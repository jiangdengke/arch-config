#!/usr/bin/env bash
# 使用 grim / slurp 完成截图，并自动保存到本地与剪贴板。
set -euo pipefail

# 截图模式：默认区域截图，也支持整屏截图。
mode="${1:-area}"

# 目标目录与文件名。
target_dir="$HOME/Pictures/Screenshots"
timestamp="$(date '+%Y-%m-%d %H-%M-%S')"
target_file="$target_dir/Screenshot from ${timestamp}.png"

# 桌面通知辅助函数。
notify() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send "$@"
}

# 缺少 grim 时无法继续截图。
if ! command -v grim >/dev/null 2>&1; then
  notify "截图失败" "系统里还没有安装 grim。"
  exit 1
fi

# 区域截图模式依赖 slurp。
if [[ "$mode" == "area" ]] && ! command -v slurp >/dev/null 2>&1; then
  notify "截图失败" "区域截图需要 slurp。"
  exit 1
fi

# 确保截图目录存在。
mkdir -p "$target_dir"

# 根据模式执行不同的截图流程。
case "$mode" in
  area)
    # 先让用户框选区域；若主动取消则静默退出。
    geometry="$(slurp)" || exit 0
    grim -g "$geometry" "$target_file"
    ;;
  screen)
    # 不传几何参数时，grim 会截取当前输出画面。
    grim "$target_file"
    ;;
  *)
    notify "截图失败" "不支持的截图模式：$mode"
    exit 1
    ;;
esac

# 把截图写入 Wayland 剪贴板，方便直接粘贴。
if command -v wl-copy >/dev/null 2>&1; then
  wl-copy --type image/png < "$target_file"
fi

# 发出完成通知。
notify "截图已保存" "$target_file"$'\n已复制到剪贴板'
