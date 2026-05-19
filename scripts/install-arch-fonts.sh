#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
font_list="$repo_root/packages/arch/font-packages.txt"

if [[ ! -f "$font_list" ]]; then
  echo "missing font package list: $font_list" >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman is required to install Arch font packages." >&2
  exit 1
fi

mapfile -t packages < <(sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' "$font_list")

if (( ${#packages[@]} == 0 )); then
  echo "no font packages listed"
  exit 0
fi

pacman_packages=()
aur_packages=()

for package in "${packages[@]}"; do
  if pacman -Si "$package" >/dev/null 2>&1; then
    pacman_packages+=("$package")
  else
    aur_packages+=("$package")
  fi
done

if (( ${#pacman_packages[@]} > 0 )); then
  sudo pacman -S --needed -- "${pacman_packages[@]}"
fi

if (( ${#aur_packages[@]} > 0 )); then
  if ! command -v paru >/dev/null 2>&1; then
    printf 'paru is required for packages not found by pacman: %s\n' "${aur_packages[*]}" >&2
    exit 1
  fi

  paru -S --needed -- "${aur_packages[@]}"
fi

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -fv
fi
