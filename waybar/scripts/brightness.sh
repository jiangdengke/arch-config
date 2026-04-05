#!/usr/bin/env bash
set -euo pipefail

# 步进：默认 1%，可通过环境变量 STEP 覆盖（如 STEP=2%）
STEP="${STEP:-1%}"
# 可选：指定设备（如 amdgpu_bl1、intel_backlight），为空则让 brightnessctl 自动选
DEVICE="${DEVICE:-}"

cmd=(brightnessctl)
[ -n "$DEVICE" ] && cmd+=(-d "$DEVICE")

case "${1:-}" in
  up|i)   "${cmd[@]}" set "${STEP}+" ;;
  down|d) "${cmd[@]}" set "${STEP}-" ;;
  set)    "${cmd[@]}" set "${2:?need percent, e.g. 50%}" ;;
  *) echo "usage: $0 [up|down|set <percent>]"; exit 1 ;;
esac

