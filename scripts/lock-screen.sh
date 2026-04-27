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

# 锁屏临时背景目录。
lock_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/lock-screen"

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

# 直接抓取当前桌面截图，并生成一张更适合锁屏的模糊背景。
capture_blurred_screenshot() {
  local raw_image lock_image

  command -v grim >/dev/null 2>&1 || return 1
  command -v magick >/dev/null 2>&1 || return 1

  mkdir -p "$lock_cache_dir"

  raw_image="$lock_cache_dir/raw-${PPID}-$$.png"
  lock_image="$lock_cache_dir/lock-${PPID}-$$.png"

  grim -t png "$raw_image" >/dev/null 2>&1 || {
    rm -f "$raw_image" "$lock_image"
    return 1
  }

  if magick "$raw_image" \
    -resize 50% \
    -blur 0x16 \
    -resize 200% \
    -fill '#11111bcc' \
    -colorize 35 \
    "$lock_image" >/dev/null 2>&1; then
    rm -f "$raw_image"
    printf '%s\n' "$lock_image"
    return 0
  fi

  rm -f "$raw_image" "$lock_image"
  return 1
}

run_swaylock_with_image() {
  local image="$1"

  trap 'rm -f "$image"' EXIT
  swaylock -C "$config_path" -i "$image"
  trap - EXIT
  rm -f "$image"
}

# 优先使用当前桌面的模糊截图，失败时再退回到壁纸缓存。
if lock_image="$(capture_blurred_screenshot)" && [[ -n "$lock_image" ]]; then
  run_swaylock_with_image "$lock_image"
  exit 0
fi

if blurred_image="$(latest_blurred_image)" && [[ -n "$blurred_image" ]]; then
  exec swaylock -C "$config_path" -i "$blurred_image"
fi

exec swaylock -C "$config_path"
