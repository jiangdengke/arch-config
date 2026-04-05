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
- `generated-at.txt`: snapshot timestamp and host metadata

These files are just snapshots of the current machine. When the software set changes, regenerate them manually and commit the updated files.

## Local-only secrets

Do not put machine-local secrets in this repo.

Use:

```bash
~/.zshrc.local
```

`zsh/.zshrc` will source that file if it exists.
