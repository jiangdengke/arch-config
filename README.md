# Arch Config

My Arch Linux dotfiles and user-space configuration.

## Managed config

- `zsh`
- `kitty`
- `niri`
- `nvim`
- `rofi`
- `waybar`
- `yazi`
- `swww`
- `git`
- `tmux`
- `fcitx5`

## Repo layout

- `zsh/`: shell config
- `kitty/`: terminal config
- `niri/`: compositor config
- `nvim/`: editor config
- `rofi/`: launcher config
- `waybar/`: bar config
- `yazi/`: file manager config and local plugins
- `fcitx5/`: input method config and themes
- `tmux/`: tmux local overrides
- `git/`: git config
- `swww/`: wallpaper helper script
- `scripts/`: maintenance/export scripts for this repo
- `packages/arch/`: exported software lists for rebuilding another Arch machine

## Install on this machine

Run:

```bash
cd ~/dotfiles
./install.sh
```

This will back up existing target files with a timestamp suffix and then create symlinks into this repo.

## Restore on another Arch machine

1. Clone this repo to `~/dotfiles`.
2. Run `./install.sh`.
3. Restore packages from `packages/arch/`.

Examples:

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
xargs -r code --install-extension < packages/arch/vscode-extensions.txt
```

If you use Code - OSS instead of VS Code:

```bash
xargs -r code-oss --install-extension < packages/arch/vscode-extensions.txt
```

## Software backup

The software inventory is exported into `packages/arch/`.

Files:

- `pacman-native.txt`: explicitly installed packages from official repos
- `pacman-foreign.txt`: explicitly installed AUR/foreign packages
- `vscode-extensions.txt`: VS Code or Code - OSS extensions
- `flatpak.txt`: Flatpak apps if Flatpak is installed
- `generated-at.txt`: export timestamp and host metadata

Refresh the inventory with:

```bash
./scripts/export-arch-software.sh
```

## What `scripts/export-arch-software.sh` does

This script is only for exporting the current machine's software list into the repo.

It does:

- `pacman -Qqen`: exports explicitly installed official-repo packages
- `pacman -Qqem`: exports explicitly installed foreign/AUR packages
- `code --list-extensions` or `code-oss --list-extensions`: exports editor extensions
- `flatpak list --app`: exports Flatpak app IDs when Flatpak exists
- writes `generated-at.txt` with time, host and kernel

It does not install anything. It only refreshes the backup lists under `packages/arch/`.

## Local-only secrets

Do not put machine-local secrets in this repo.

Use:

```bash
~/.zshrc.local
```

`zsh/.zshrc` will source that file if it exists.
