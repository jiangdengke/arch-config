#!/usr/bin/env bash
set -euo pipefail

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send "$@"
}

refresh_waybar() {
  pkill -USR2 -x waybar >/dev/null 2>&1 || true
}

controller_available() {
  bluetoothctl show >/dev/null 2>&1
}

powered() {
  bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2; exit}'
}

open_manager() {
  if command -v blueman-manager >/dev/null 2>&1; then
    export GTK_THEME=Orchis-Dark
    exec blueman-manager
  fi

  notify "Bluetooth" "未安装 blueman-manager"
}

toggle_power() {
  if ! command -v bluetoothctl >/dev/null 2>&1; then
    notify "Bluetooth" "bluetoothctl 未安装"
    exit 0
  fi

  if ! controller_available; then
    notify "Bluetooth" "未检测到可用的蓝牙控制器"
    exit 0
  fi

  if [[ "$(powered)" == "yes" ]]; then
    bluetoothctl power off >/dev/null 2>&1 || true
    notify "Bluetooth" "Disabled"
  else
    bluetoothctl power on >/dev/null 2>&1 || true
    notify "Bluetooth" "Enabled"
  fi

  refresh_waybar
}

case "${1:-toggle}" in
  toggle)
    toggle_power
    ;;
  manager|open)
    open_manager
    ;;
  *)
    printf 'usage: %s [toggle|manager]\n' "$0" >&2
    exit 1
    ;;
esac
