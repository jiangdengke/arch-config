# Arch Config

[English](README.en.md)

这是我的 Arch Linux 用户态配置仓库。

## 当前管理的配置

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

## 目录说明

- `zsh/`：shell 配置
- `kitty/`：终端配置
- `niri/`：Wayland 合成器配置
- `rofi/`：启动器配置
- `waybar/`：状态栏配置
- `yazi/`：Yazi 配置和本地插件
- `fcitx5/`：输入法配置和主题
- `tmux/`：tmux 基础配置和本地覆盖配置
- `git/`：Git 配置
- `swww/`：壁纸脚本
- `packages/arch/`：当前机器的软件清单快照

说明：`nvim` 不在这个仓库里备份，因为我直接使用 LazyVim。

## 本机安装

```bash
cd ~/dotfiles
./install.sh
```

脚本会先把已有文件备份成带时间戳的 `.bak.*`，再创建软链接到本仓库。
目前会接管的主要目标包括：`~/.zshrc`、`~/.zprofile`、`~/.zimrc`、`~/.gitconfig`、`~/.tmux.conf`、`~/.tmux.conf.local`，以及对应的 `~/.config/*` 目录。

## 在另一台 Arch 上恢复

1. 把仓库克隆到 `~/dotfiles`
2. 先按 `packages/arch/` 里的清单安装软件
3. 再执行 `./install.sh`

示例：

```bash
git clone git@github.com:jiangdengke/arch-config.git ~/dotfiles
cd ~/dotfiles

xargs -r sudo pacman -S --needed -- < packages/arch/pacman-native.txt

# 如果目标机器还没有 paru，请先手动安装 paru，再恢复 AUR / foreign 包
xargs -r paru -S --needed -- < packages/arch/pacman-foreign.txt

./install.sh
```

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
