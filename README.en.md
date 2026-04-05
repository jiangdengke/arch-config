# Arch Config

[中文](README.md)

This is my Arch Linux user-space configuration repository.

## Managed config

- `zsh`
- `kitty`
- `niri`
- `rofi`
- `waybar`
- `yazi`
- `swww`
- `git`
- `tmux`
- `fcitx5`

## Layout

- `zsh/`: shell config
- `kitty/`: terminal config
- `niri/`: compositor config
- `rofi/`: launcher config
- `waybar/`: bar config
- `yazi/`: Yazi config and local plugins
- `fcitx5/`: input method config and themes
- `tmux/`: tmux local overrides
- `git/`: Git config
- `swww/`: wallpaper helper script
- `packages/arch/`: software inventory snapshots from the current machine

Note: `nvim` is not backed up in this repo because I use LazyVim directly.

## Install on this machine

```bash
cd ~/dotfiles
./install.sh
```

The script backs up existing targets with a timestamped `.bak.*` suffix, then creates symlinks into this repo.

## Restore on another Arch machine

1. Clone this repo to `~/dotfiles`
2. Run `./install.sh`
3. Install packages from `packages/arch/`

Example:

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
```

## Software inventory

`packages/arch/` stores snapshots of the current machine:

- `pacman-native.txt`: explicitly installed packages from official repos
- `pacman-foreign.txt`: explicitly installed AUR / foreign packages
- `flatpak.txt`: Flatpak applications, if present

These files are snapshots only. They do not perform installation.

## Local-only secrets

Do not store machine-local secrets in this repo.

Use:

```bash
~/.zshrc.local
```

`zsh/.zshrc` sources it when present.
