#!/usr/bin/env bash
# 使用 wl-screenrec 录屏；再次运行同一模式会停止当前录制。
set -euo pipefail

mode="${1:-screen}"
audio="${2:-audio}"
target_dir="$HOME/Videos/Recordings"
runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
pid_file="$runtime_dir/record-screen.pid"
file_file="$runtime_dir/record-screen.file"
mode_file="$runtime_dir/record-screen.mode"
audio_file="$runtime_dir/record-screen.audio"
log_file="$runtime_dir/record-screen.log"

notify() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send "$@"
}

is_recording() {
  [[ -f "$pid_file" ]] || return 1
  local pid
  pid="$(<"$pid_file")"
  [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

stop_recording() {
  local pid file
  pid="$(<"$pid_file")"
  file="$(cat "$file_file" 2>/dev/null || true)"

  kill -INT "$pid" 2>/dev/null || true

  # Give ffmpeg a moment to flush the container before reporting completion.
  for _ in {1..30}; do
    kill -0 "$pid" 2>/dev/null || break
    sleep 0.1
  done

  rm -f "$pid_file" "$file_file" "$mode_file" "$audio_file"
  notify "录屏已停止" "${file:-视频已保存。}"
}

if is_recording; then
  stop_recording
  exit 0
fi

if ! command -v wl-screenrec >/dev/null 2>&1; then
  notify "录屏失败" "系统里还没有安装 wl-screenrec。"
  exit 1
fi

if [[ "$mode" == "area" ]] && ! command -v slurp >/dev/null 2>&1; then
  notify "录屏失败" "区域录屏需要 slurp。"
  exit 1
fi

mkdir -p "$target_dir"

timestamp="$(date '+%Y-%m-%d %H-%M-%S')"
case "$audio" in
  audio|with-audio)
    audio_enabled=1
    audio_label="有声"
    ;;
  no-audio|silent)
    audio_enabled=0
    audio_label="无声"
    ;;
  *)
    notify "录屏失败" "不支持的声音模式：$audio"
    exit 1
    ;;
esac

target_file="$target_dir/Recording ${audio_label} from ${timestamp}.mp4"
args=(--low-power=off --max-fps 60 -f "$target_file")

case "$mode" in
  screen)
    title="全屏录制已开始"
    ;;
  area)
    geometry="$(slurp)" || exit 0
    args=(-g "$geometry" "${args[@]}")
    title="区域录制已开始"
    ;;
  *)
    notify "录屏失败" "不支持的录屏模式：$mode"
    exit 1
    ;;
esac

if (( audio_enabled )); then
  args=(--audio "${args[@]}")
fi

wl-screenrec "${args[@]}" >"$log_file" 2>&1 &
pid="$!"

printf '%s\n' "$pid" > "$pid_file"
printf '%s\n' "$target_file" > "$file_file"
printf '%s\n' "$mode" > "$mode_file"
printf '%s\n' "$audio" > "$audio_file"

sleep 0.3
if ! kill -0 "$pid" 2>/dev/null; then
  rm -f "$pid_file" "$file_file" "$mode_file" "$audio_file"
  notify "录屏启动失败" "$(tail -n 3 "$log_file" 2>/dev/null)"
  exit 1
fi

notify "$title（${audio_label}）" "$target_file"$'\n再次按快捷键停止录制。'
