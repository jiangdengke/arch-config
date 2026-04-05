#!/usr/bin/env bash
set -euo pipefail
STEP="${STEP:-5}"

op=""
if [ "${1:-}" = "-o" ]; then op="${2:-}"; else op="${1:-}"; fi
case "$op" in
  i|up)    ACT=inc ;;
  d|down)  ACT=dec ;;
  m|mute)  ACT=toggle ;;
  *) echo "usage: $0 [-o i|d|m] | [up|down|mute]" >&2; exit 1 ;;
esac

if command -v pamixer >/dev/null 2>&1; then
  case "$ACT" in
    inc) pamixer --increase "$STEP" ;;
    dec) pamixer --decrease "$STEP" ;;
    toggle) pamixer -t ;;
  esac
else
  SINK="@DEFAULT_SINK@"
  case "$ACT" in
    inc) pactl set-sink-volume "$SINK" +"${STEP}%" ;;
    dec) pactl set-sink-volume "$SINK" -"${STEP}%" ;;
    toggle) pactl set-sink-mute "$SINK" toggle ;;
  esac
fi
