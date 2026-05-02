#!/usr/bin/env bash
set -euo pipefail

# 解析 dotfiles 仓库根目录，保证脚本可在任意目录运行。
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

timestamp() {
  date +"%Y%m%d-%H%M%S"
}

backup_path() {
  local path="$1"
  local ts
  ts="$(timestamp)"
  echo "${path}.bak.${ts}"
}

link_file() {
  local src="$1"
  local dst="$2"

  # 源文件不存在时跳过，便于脚本重复执行。
  if [[ ! -e "$src" ]]; then
    echo "skip: missing source $src"
    return 0
  fi

  # 如果已经正确链接，则不做任何操作。
  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      echo "ok: $dst already linked"
      return 0
    fi
  fi

  # 目标已存在则备份，避免覆盖用户文件。
  if [[ -e "$dst" || -L "$dst" ]]; then
    local bak
    bak="$(backup_path "$dst")"
    mv "$dst" "$bak"
    echo "backup: $dst -> $bak"
  fi

  # 创建软链接。
  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

# 基础目录
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/environment.d"
mkdir -p "$HOME/.config/fontconfig/conf.d"
mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/.config/fcitx5/conf"
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"
mkdir -p "$HOME/.config/qt5ct"
mkdir -p "$HOME/.config/qt6ct"
mkdir -p "$HOME/.local/share/fcitx5"
mkdir -p "$HOME/.local/share/fcitx5/rime"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Pictures/images"

# Zsh
link_file "$repo_root/zsh/.zshrc" "$HOME/.zshrc"
link_file "$repo_root/zsh/.zprofile" "$HOME/.zprofile"
link_file "$repo_root/zsh/.zimrc" "$HOME/.zimrc"

# 桌面/应用配置
link_file "$repo_root/kitty" "$HOME/.config/kitty"
link_file "$repo_root/mako" "$HOME/.config/mako"
link_file "$repo_root/environment.d/90-qt.conf" "$HOME/.config/environment.d/90-qt.conf"
link_file "$repo_root/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
link_file "$repo_root/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
link_file "$repo_root/qt5ct/qt5ct.conf" "$HOME/.config/qt5ct/qt5ct.conf"
link_file "$repo_root/qt6ct/qt6ct.conf" "$HOME/.config/qt6ct/qt6ct.conf"
link_file "$repo_root/hypr" "$HOME/.config/hypr"
link_file "$repo_root/niri" "$HOME/.config/niri"
link_file "$repo_root/rofi" "$HOME/.config/rofi"
link_file "$repo_root/swaylock" "$HOME/.config/swaylock"
link_file "$repo_root/waybar" "$HOME/.config/waybar"
link_file "$repo_root/yazi" "$HOME/.config/yazi"
link_file "$repo_root/fontconfig/conf.d/60-fcitx5-ui-fonts.conf" "$HOME/.config/fontconfig/conf.d/60-fcitx5-ui-fonts.conf"
link_file "$repo_root/fontconfig/conf.d/61-zh-fonts.conf" "$HOME/.config/fontconfig/conf.d/61-zh-fonts.conf"
link_file "$repo_root/swww/swww-random.sh" "$HOME/.config/swww-random.sh"
link_file "$repo_root/scripts/lock-screen.sh" "$HOME/.local/bin/lock-screen"
link_file "$repo_root/scripts/screenshot.sh" "$HOME/.local/bin/screenshot"
link_file "$repo_root/scripts/toggle-mako-dnd.sh" "$HOME/.local/bin/toggle-mako-dnd"

# Git
link_file "$repo_root/git/.gitconfig" "$HOME/.gitconfig"

# Tmux (gpakosz/.tmux)
link_file "$repo_root/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$repo_root/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"

# Fcitx5
link_file "$repo_root/fcitx5/config" "$HOME/.config/fcitx5/config"
link_file "$repo_root/fcitx5/profile" "$HOME/.config/fcitx5/profile"
link_file "$repo_root/fcitx5/conf/classicui.conf" "$HOME/.config/fcitx5/conf/classicui.conf"
link_file "$repo_root/fcitx5/themes" "$HOME/.local/share/fcitx5/themes"
link_file "$repo_root/fcitx5/rime/default.custom.yaml" "$HOME/.local/share/fcitx5/rime/default.custom.yaml"
