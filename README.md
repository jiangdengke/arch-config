# Arch Config

[English](README.en.md)

这是我的 Arch Linux 用户态配置仓库。

## 当前管理的配置

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

## 目录说明

- `zsh/`：shell 配置
- `kitty/`：终端配置
- `hypr/`：Hyprlock 锁屏配置和启动脚本
- `niri/`：Wayland 合成器配置
- `mako/`：通知守护进程配置
- `rofi/`：启动器配置
- `swaylock/`：锁屏配置
- `waybar/`：状态栏配置
- `yazi/`：Yazi 配置和本地插件
- `scripts/`：本地辅助脚本，例如锁屏、截图、通知开关
- `fcitx5/`：输入法配置和主题
- `tmux/`：tmux 基础配置和本地覆盖配置
- `git/`：Git 配置
- `swww/`：兼容 `swww` / `awww` 的壁纸脚本
- `packages/arch/`：当前机器的软件清单快照

说明：`nvim` 不在这个仓库里备份，因为我直接使用 LazyVim。

## 本机安装

```bash
cd ~/arch-config
./install.sh
```

脚本会先把已有文件备份成带时间戳的 `.bak.*`，再创建软链接到本仓库。
目前会接管的主要目标包括：`~/.zshrc`、`~/.zprofile`、`~/.zimrc`、`~/.gitconfig`、`~/.tmux.conf`、`~/.tmux.conf.local`，以及对应的 `~/.config/*` 目录。
还会接管 `~/.config/mako`、`~/.config/swaylock`，并把辅助脚本链接到 `~/.local/bin/lock-screen`、`~/.local/bin/screenshot`、`~/.local/bin/toggle-mako-dnd`。

## 在另一台 Arch 上恢复

1. 把仓库克隆到 `~/arch-config`
2. 先按 `packages/arch/` 里的清单安装软件
3. 再执行 `./install.sh`
4. 如果希望登录 shell 也是 `zsh`，再执行 `chsh -s /usr/bin/zsh`

示例：

```bash
git clone git@github.com:jiangdengke/arch-config.git ~/arch-config
cd ~/arch-config

xargs -r sudo pacman -S --needed -- < packages/arch/pacman-native.txt

# 如果目标机器还没有 paru，请先手动安装 paru，再恢复 AUR / foreign 包
xargs -r paru -S --needed -- < packages/arch/pacman-foreign.txt

./install.sh

# 如果想把账户默认 shell 也切成 zsh
chsh -s /usr/bin/zsh
```

截图、锁屏、通知链路依赖的核心包也已经纳入清单：`mako`、`hyprlock`、`swaylock`、`grim`、`slurp`、`wl-clipboard`、`libnotify`。
默认锁屏快捷键 `Super+Alt+L` 现在会启动 Hyprlock；仓库仍保留 `swaylock` 配置和旧脚本作为回退方案。
壁纸脚本会优先扫描 `~/Pictures/images`，并继续兼容 `~/Pictures/images/images`、`~/Pictures/wallpapers`、`~/Pictures/Wallpapers`、`~/Pictures` 和 `/usr/share/backgrounds`。
`install.sh` 会顺手创建 `~/Pictures/images`，新机器把图片放进去即可。

## 软件清单

`packages/arch/` 里保存的是这台机器当前的软件快照：

- `pacman-native.txt`：官方仓库里显式安装的包
- `pacman-foreign.txt`：AUR / foreign 包
- `flatpak.txt`：Flatpak 应用，如果存在

这些文件只是快照，不负责安装。

## 本地私有配置

不要把机器私有密钥或 token 放进仓库。

本地私有内容放到：

```bash
~/.zshrc.local
```

`zsh/.zshrc` 会在这个文件存在时自动加载它。

Git 的本机私有覆盖可放到：

```bash
~/.config/git/config.local
```

例如本机代理配置就适合放这里，不要直接写进仓库里的 `.gitconfig`。
