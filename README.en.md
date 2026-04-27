# Arch Config

[中文](README.md)

This is my Arch Linux user-space configuration repository.

## Managed config

- `zsh`
- `kitty`
- `hyprlock`
- `niri`
- `mako`
- `rofi`
- `swaylock`
- `waybar`
- `yazi`
- `swww`
- `scripts`
- `git`
- `tmux`
- `fcitx5`

## Layout

- `zsh/`: shell config
- `kitty/`: terminal config
- `hypr/`: Hyprlock config and launcher
- `niri/`: compositor config
- `mako/`: notification daemon config
- `rofi/`: launcher config
- `swaylock/`: lock screen config
- `waybar/`: bar config
- `yazi/`: Yazi config and local plugins
- `scripts/`: helper scripts such as lock-screen, screenshot, and notification toggles
- `fcitx5/`: input method config and themes
- `tmux/`: tmux base config and local overrides
- `git/`: Git config
- `swww/`: wallpaper helper script compatible with `swww` and `awww`
- `packages/arch/`: software inventory snapshots from the current machine

Note: `nvim` is not backed up in this repo because I use LazyVim directly.

## Install on this machine

```bash
cd ~/arch-config
./install.sh
```

The script backs up existing targets with a timestamped `.bak.*` suffix, then creates symlinks into this repo.
The main managed targets include `~/.zshrc`, `~/.zprofile`, `~/.zimrc`, `~/.gitconfig`, `~/.tmux.conf`, `~/.tmux.conf.local`, and the related `~/.config/*` directories.
It also manages `~/.config/mako`, `~/.config/swaylock`, and links helper scripts into `~/.local/bin/lock-screen`, `~/.local/bin/screenshot`, and `~/.local/bin/toggle-mako-dnd`.

## Restore on another Arch machine

1. Clone this repo to `~/arch-config`
2. Install packages from `packages/arch/` first
3. Run `./install.sh`
4. If you want the login shell to be `zsh` as well, run `chsh -s /usr/bin/zsh`

Example:

```bash
git clone git@github.com:jiangdengke/arch-config.git ~/arch-config
cd ~/arch-config

xargs -r sudo pacman -S --needed -- < packages/arch/pacman-native.txt

# If `paru` is not installed yet, install it first, then restore AUR / foreign packages.
xargs -r paru -S --needed -- < packages/arch/pacman-foreign.txt

./install.sh

# If you also want the account login shell to default to zsh
chsh -s /usr/bin/zsh
```

The screenshot, lock-screen, and notification flow now depends on `mako`, `hyprlock`, `swaylock`, `grim`, `slurp`, `wl-clipboard`, and `libnotify`, and these are tracked in the package inventory.
The default `Super+Alt+L` lock-screen binding now launches Hyprlock; the repo still keeps the `swaylock` config and legacy script as a fallback path.
The wallpaper helper now prefers `~/Pictures/images`, while still scanning `~/Pictures/images/images`, `~/Pictures/wallpapers`, `~/Pictures/Wallpapers`, `~/Pictures`, and `/usr/share/backgrounds`.
`install.sh` also creates `~/Pictures/images` so a fresh machine has a conventional drop-in wallpaper directory.

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

For machine-local Git overrides, use:

```bash
~/.config/git/config.local
```

This is a good place for per-machine proxy settings that should not live in the repo copy of `.gitconfig`.
