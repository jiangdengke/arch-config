#!/usr/bin/env bash
# 基于 swww / awww 随机切换壁纸的脚本（带过渡动画）。
# 该脚本会在 Wayland 会话中寻找指定目录里的图片文件，随机挑选一张并通过可用后端显示。
# 由于会被 niri 在启动时直接调用，需要具备自恢复能力：未找到会话、目录或图片时静默退出。
set -euo pipefail

# 目标壁纸目录：优先使用第一个参数，否则使用默认目录。
dir="${1:-$HOME/Pictures/images/images}"

# 若目录不存在则直接退出，避免报错打断登录流程。
if [[ ! -d "$dir" ]]; then
  exit 0
fi

# 尝试确保脚本运行在有效的 Wayland 会话中。
ensure_wayland_display() {
  # 如果环境变量中已有 WAYLAND_DISPLAY，则认为当前会话可用。
  if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    return 0
  fi

  # 没有 XDG_RUNTIME_DIR 意味着无权访问 Wayland 套接字，直接失败。
  if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
    return 1
  fi

  # 在共享运行目录下寻找 wayland-* 套接字，匹配到即导出变量后返回成功。
  for socket in "$XDG_RUNTIME_DIR"/wayland-*; do
    if [[ -S "$socket" ]]; then
      export WAYLAND_DISPLAY="${socket##*/}"
      return 0
    fi
  done

  # 没有找到任何有效套接字，返回失败。
  return 1
}

# 如果当前尚未建立 Wayland 会话，等待最多 30 秒重试以覆盖登录早期的竞态。
if ! ensure_wayland_display; then
  for _ in {1..30}; do
    sleep 1
    ensure_wayland_display && break
  done
fi

# 30 秒内仍未找到 Wayland 环境，则无需继续执行。
if [[ -z "${WAYLAND_DISPLAY:-}" ]]; then
  exit 0
fi

# Overview backdrop 使用的单独命名空间。
overview_namespace="overview-backdrop"

# Overview backdrop 模糊壁纸缓存目录。
blur_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/niri/overview-backdrop"

# 自动探测可用壁纸后端，优先使用 swww，其次兼容 awww。
if command -v swww >/dev/null 2>&1 && command -v swww-daemon >/dev/null 2>&1; then
  wallpaper_client=(swww)
  wallpaper_daemon=(swww-daemon)
  wallpaper_daemon_name="swww-daemon"
elif command -v awww >/dev/null 2>&1 && command -v awww-daemon >/dev/null 2>&1; then
  wallpaper_client=(awww)
  wallpaper_daemon=(awww-daemon)
  wallpaper_daemon_name="awww-daemon"
else
  exit 0
fi

# 避免使用外部注入的错误 socket 环境变量。
unset SWWW_SOCKET
unset AWWW_SOCKET

# 检查指定命名空间的壁纸守护进程是否已经可响应。
query_wallpaper() {
  local namespace="${1:-}"

  if [[ -n "$namespace" ]]; then
    "${wallpaper_client[@]}" query --namespace "$namespace" >/dev/null 2>&1
  else
    "${wallpaper_client[@]}" query >/dev/null 2>&1
  fi
}

# 启动指定命名空间的壁纸守护进程。
start_wallpaper_daemon() {
  local namespace="${1:-}"

  if [[ -n "$namespace" ]]; then
    "${wallpaper_daemon[@]}" --namespace "$namespace" >/dev/null 2>&1 &
  else
    "${wallpaper_daemon[@]}" >/dev/null 2>&1 &
  fi
}

# 确保指定命名空间的壁纸守护进程已启动并可用。
ensure_wallpaper_daemon() {
  local namespace="${1:-}"

  if ! query_wallpaper "$namespace"; then
    start_wallpaper_daemon "$namespace"
  fi

  for _ in {1..20}; do
    if query_wallpaper "$namespace"; then
      return 0
    fi
    sleep 0.1
  done

  return 1
}

# 为指定图片生成一张模糊版，供 Overview backdrop 使用。
generate_blurred_wallpaper() {
  local img="$1"
  local stamp key out tmp

  command -v magick >/dev/null 2>&1 || return 1

  mkdir -p "$blur_cache_dir"

  stamp="$(stat -c '%Y:%s' "$img" 2>/dev/null || printf '0:0')"
  key="$(printf '%s|%s\n' "$img" "$stamp" | sha1sum | awk '{print $1}')"
  out="$blur_cache_dir/${key}.png"

  if [[ -f "$out" ]]; then
    printf '%s\n' "$out"
    return 0
  fi

  tmp="${out}.tmp.$$"

  if magick "$img" \
    -resize 50% \
    -blur 0x18 \
    -resize 200% \
    "$tmp" >/dev/null 2>&1; then
    mv "$tmp" "$out"
    printf '%s\n' "$out"
    return 0
  fi

  rm -f "$tmp"
  return 1
}

# 进入主循环：每次挑选壁纸后休眠 300 秒，再次扫描目录，确保新增/删除图片能被感知。
while true; do
  # 搜索壁纸目录下的常见图片格式，mapfile 读入数组并排序以获得稳定选择序列。
  mapfile -t files < <(find "$dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.bmp' \) | sort)

  # 当目录里没有符合条件的图片时，不做任何操作提前返回。
  if [[ ${#files[@]} -eq 0 ]]; then
    exit 0
  fi

  # 使用 Bash 内置 RANDOM 从数组中随机抽取一张图片。
  img="${files[$((RANDOM % ${#files[@]}))]}"

  # 确保主壁纸守护进程已启动并就绪。
  if ! ensure_wallpaper_daemon; then
    sleep 5
    continue
  fi

  # 使用当前后端切换壁纸并启用淡入过渡。
  if ! "${wallpaper_client[@]}" img "$img" --transition-type fade --transition-duration 1.0 >/dev/null 2>&1; then
    sleep 5
    continue
  fi

  # 为 Overview 生成模糊版 backdrop。
  if blurred_img="$(generate_blurred_wallpaper "$img")"; then
    if ensure_wallpaper_daemon "$overview_namespace"; then
      "${wallpaper_client[@]}" img "$blurred_img" --namespace "$overview_namespace" --transition-type fade --transition-duration 1.0 >/dev/null 2>&1 || true
    fi
  fi

  # 每五分钟刷新一次，若脚本被外部终止则会提前结束循环。
  sleep 300
done
