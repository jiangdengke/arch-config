#!/usr/bin/env bash
# 使用 swaylock 锁屏，并优先复用 niri Overview 的模糊壁纸缓存。
set -euo pipefail

# 若系统未安装 swaylock，则直接退出，避免出现 shell 报错。
if ! command -v swaylock >/dev/null 2>&1; then
  command -v notify-send >/dev/null 2>&1 && notify-send "锁屏失败" "系统里还没有安装 swaylock。"
  exit 1
fi

# swaylock 配置文件路径。
config_path="$HOME/.config/swaylock/config"

# Overview 模糊壁纸缓存目录。
blur_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/niri/overview-backdrop"

# 从缓存目录里选出最近生成的一张模糊壁纸。
latest_blurred_image() {
  # 缓存目录不存在时直接返回失败。
  [[ -d "$blur_cache_dir" ]] || return 1

  # 按修改时间倒序排序，取最新一张 PNG。
  find "$blur_cache_dir" -maxdepth 1 -type f -name '*.png' -printf '%T@ %p\n' 2>/dev/null \
    | sort -nr \
    | head -n 1 \
    | cut -d' ' -f2-
}

# 有模糊壁纸时直接作为锁屏背景，否则退回 swaylock 配置里的纯色背景。
if blurred_image="$(latest_blurred_image)" && [[ -n "$blurred_image" ]]; then
  exec swaylock -C "$config_path" -i "$blurred_image"
fi

exec swaylock -C "$config_path"
