#!/usr/bin/env bash
set -euo pipefail

if command -v hyprlock >/dev/null 2>&1; then
  exec hyprlock --immediate-render --config "$HOME/.config/hypr/hyprlock.conf"
fi

exec "$HOME/.local/bin/lock-screen"
