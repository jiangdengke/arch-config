#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# -------- 选择器：优先 wofi → rofi → fzf --------
picker() {
  local prompt="${2:-Bluetooth}"
  if command -v wofi >/dev/null 2>&1; then
    wofi --dmenu -p "$prompt"
  elif command -v rofi >/dev/null 2>&1; then
    rofi -dmenu -i -p "$prompt"
  else
    fzf --prompt="${prompt}> "
  fi
}

notify() { command -v notify-send >/dev/null 2>&1 && notify-send "$@"; }
powered() { bluetoothctl show | awk '/Powered:/ {print $2; exit}'; }
connected_p() { bluetoothctl info "$1" 2>/dev/null | awk '/Connected:/ {print $2; exit}'; }

# 图标：优先用 bluetoothctl info 的 Icon 字段；扫描时按名称猜测
icon_for_mac() {
  local mac="$1" info icon
  info="$(bluetoothctl info "$mac" 2>/dev/null || true)"
  icon="$(echo "$info" | awk '/Icon:/ {print $2; exit}')"
  case "$icon" in
    audio-headphones|audio-headset) echo "󰋋" ;;   # 耳机/头戴
    audio-speakers)                 echo "󰓃" ;;   # 音箱
    audio-input-microphone)         echo "󰍬" ;;   # 麦克风
    input-keyboard)                 echo "󰌌" ;;   # 键盘
    input-mouse)                    echo "󰍽" ;;   # 鼠标
    phone)                          echo "󰏲" ;;   # 手机
    computer|video-display)         echo "󰍹" ;;   # 电脑/显示器
    *)                              echo "󰂱" ;;   # 默认
  esac
}

icon_guess_by_name() {
  local name_lc="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  if   [[ "$name_lc" =~ (headset|headphone|buds|earbud|h1|sony|baseus|airpods) ]]; then echo "󰋋"
  elif [[ "$name_lc" =~ (keyboard|kb|keychron|rk) ]]; then echo "󰌌"
  elif [[ "$name_lc" =~ (mouse|mx|logitech) ]]; then echo "󰍽"
  elif [[ "$name_lc" =~ (speaker|sound|boom|hifi) ]]; then echo "󰓃"
  elif [[ "$name_lc" =~ (phone|iphone|android|pixel|xiaomi|huawei|oneplus|redmi|oppo) ]]; then echo "󰏲"
  else echo "󰂱"; fi
}

# 已配对设备（MAC\tICON\tNAME\t[connected]）
list_paired() {
  bluetoothctl devices | while read -r _ mac rest; do
    [ -z "${mac:-}" ] && continue
    name="$(bluetoothctl info "$mac" 2>/dev/null | awk -F': ' '/Name:/{print $2; exit}')"
    [ -z "$name" ] && name="$rest"
    icn="$(icon_for_mac "$mac")"
    if [ "$(connected_p "$mac")" = "yes" ]; then
      printf "%s\t%s\t%s\t[connected]\n" "$mac" "$icn" "$name"
    else
      printf "%s\t%s\t%s\n" "$mac" "$icn" "$name"
    fi
  done
}

# 扫描 N 秒（默认 12s），返回 MAC\tICON\tNAME
scan_devices() {
  local timeout="${1:-12}"
  mapfile -t found < <(bluetoothctl --timeout "$timeout" scan on \
    | awk '/^Device /{mac=$2; $1=$2=""; name=substr($0,3); print mac "\t" name}' | sort -u)
  for line in "${found[@]}"; do
    mac="${line%%$'\t'*}"
    name="${line#*$'\t'}"
    icn="$(icon_guess_by_name "$name")"
    printf "%s\t%s\t%s\n" "$mac" "$icn" "$name"
  done
}

main_menu() {
  if [ "$(powered)" != "yes" ]; then
    choice="$(printf '%s\n' '  Enable Bluetooth' | picker 'Bluetooth')"
    [ -z "${choice:-}" ] && exit 0
    bluetoothctl power on >/dev/null 2>&1 || true
    notify "Bluetooth" "Enabled"
    exit 0
  fi

  paired="$(list_paired)"
  header1="  Scan & Pair…"
  header2="  Disable Bluetooth"

  menu="$(printf '%s\n%s\n%s\n' "$header1" "$header2" "$paired")"

  # 对齐展示
  if command -v column >/dev/null 2>&1; then
    shown="$(echo -e "$menu" | column -t -s $'\t')"
  else
    shown="$menu"
  fi

  choice="$(echo -e "$shown" | picker 'Bluetooth')"
  [ -z "${choice:-}" ] && exit 0

  case "$choice" in
    "$header2")
      bluetoothctl power off >/dev/null 2>&1 || true
      notify "Bluetooth" "Disabled"
      exit 0
      ;;
    "$header1")
      do_scan_pair
      exit 0
      ;;
    *)
      # 把第一个“字段”当作 MAC（column 对齐也适用）
      mac="$(echo "$choice" | awk '{print $1}')"
      if [[ ! "$mac" =~ ^([0-9A-F]{2}:){5}[0-9A-F]{2}$ ]]; then
        # 回退：从未对齐列表里用名称匹配取回 MAC
        name="$(echo "$choice" | sed 's/.*\t//; s/ \[connected\]$//')"
        mac="$(printf '%s\n' "$paired" | awk -F'\t' -v n="$name" '$3==n{print $1; exit}')"
      fi
      [ -z "$mac" ] && exit 0

      if [ "$(connected_p "$mac")" = "yes" ]; then
        bluetoothctl disconnect "$mac" >/dev/null 2>&1 || true
        notify "Bluetooth" "Disconnected"
      else
        bluetoothctl agent on >/dev/null 2>&1 || true
        bluetoothctl default-agent >/dev/null 2>&1 || true
        bluetoothctl trust "$mac"  >/dev/null 2>&1 || true
        bluetoothctl pair  "$mac"  >/dev/null 2>&1 || true
        bluetoothctl connect "$mac" >/dev/null 2>&1 || true
        sleep 2
        if [ "$(connected_p "$mac")" = "yes" ]; then
          n="$(bluetoothctl info "$mac" | awk -F': ' '/Name:/{print $2; exit}')"
          notify "Bluetooth" "Connected: ${n:-$mac}"
        else
          notify "Bluetooth" "Failed to connect"
        fi
      fi
      ;;
  esac
}

do_scan_pair() {
  notify "Bluetooth" "Scanning…"
  mapfile -t devs < <(scan_devices 12)

  # 过滤已配对
  mapfile -t paired_macs < <(printf '%s\n' "$paired" | awk -F'\t' '{print $1}')
  show=()
  for line in "${devs[@]:-}"; do
    mac="${line%%$'\t'*}"
    skip=0
    for pm in "${paired_macs[@]:-}"; do [ "$mac" = "$pm" ] && skip=1 && break; done
    [ $skip -eq 0 ] && show+=("$line")
  done

  if [ "${#show[@]:-0}" -eq 0 ]; then
    notify "Bluetooth" "No new devices"
    return
  fi

  if command -v column >/dev/null 2>&1; then
    shown="$(printf '%s\n' "${show[@]}" | column -t -s $'\t')"
  else
    shown="$(printf '%s\n' "${show[@]}")"
  fi
  pickline="$(echo -e "$shown" | picker 'Scan & Pair')"
  [ -z "${pickline:-}" ] && return

  mac="$(echo "$pickline" | awk '{print $1}')"
  bluetoothctl agent on >/dev/null 2>&1 || true
  bluetoothctl default-agent >/dev/null 2>&1 || true
  bluetoothctl trust "$mac"  >/dev/null 2>&1 || true
  bluetoothctl pair  "$mac"  >/dev/null 2>&1 || true
  bluetoothctl connect "$mac" >/dev/null 2>&1 || true
  sleep 2
  if [ "$(connected_p "$mac")" = "yes" ]; then
    n="$(bluetoothctl info "$mac" | awk -F': ' '/Name:/{print $2; exit}')"
    notify "Bluetooth" "Paired & connected: ${n:-$mac}"
  else
    notify "Bluetooth" "Pair/connect failed"
  fi
}

main_menu

