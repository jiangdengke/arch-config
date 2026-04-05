# Arch Config

## 中文说明

这是我的 Arch Linux 用户态 dotfiles 仓库。

### 当前管理的配置

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

### 目录说明

- `zsh/`：shell 配置
- `kitty/`：终端配置
- `niri/`：Wayland 合成器配置
- `nvim/`：LazyVim 基础上的本地补充配置，可选恢复
- `rofi/`：启动器配置
- `waybar/`：状态栏配置
- `yazi/`：Yazi 配置和本地插件
- `fcitx5/`：输入法配置和主题
- `tmux/`：tmux 本地覆盖配置
- `git/`：Git 配置
- `swww/`：壁纸脚本
- `packages/arch/`：当前机器的软件清单快照

### 本机安装

```bash
cd ~/dotfiles
./install.sh
```

脚本会先把已有文件备份成带时间戳的 `.bak.*`，再创建软链接到本仓库。

### 在另一台 Arch 上恢复

1. 把仓库克隆到 `~/dotfiles`
2. 执行 `./install.sh`
3. 再按 `packages/arch/` 里的清单装软件

示例：

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
xargs -r code --install-extension < packages/arch/vscode-extensions.txt
```

如果你用的是 Code - OSS：

```bash
xargs -r code-oss --install-extension < packages/arch/vscode-extensions.txt
```

说明：`nvim/` 不是重点备份项，因为编辑器主体基于 LazyVim，上游可重建；仓库里保留的只是本地补充配置和锁定文件。

### 软件清单

`packages/arch/` 里保存的是这台机器当前的软件快照：

- `pacman-native.txt`：官方仓库里显式安装的包
- `pacman-foreign.txt`：AUR / foreign 包
- `vscode-extensions.txt`：VS Code / Code - OSS 扩展
- `flatpak.txt`：Flatpak 应用
- `generated-at.txt`：导出时间、主机名、内核版本

这些文件只是快照，不负责安装。软件有变化时，手动刷新这些文件再提交即可。

### 本地私有配置

不要把机器私有密钥或 token 放进仓库。

本地私有内容放到：

```bash
~/.zshrc.local
```

`zsh/.zshrc` 会在这个文件存在时自动加载它。

## English

This is my Arch Linux user-space dotfiles repository.

### Managed config

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

### Layout

- `zsh/`: shell config
- `kitty/`: terminal config
- `niri/`: compositor config
- `nvim/`: optional local additions on top of LazyVim
- `rofi/`: launcher config
- `waybar/`: bar config
- `yazi/`: Yazi config and local plugins
- `fcitx5/`: input method config and themes
- `tmux/`: tmux local overrides
- `git/`: Git config
- `swww/`: wallpaper helper script
- `packages/arch/`: software inventory snapshots from the current machine

### Install on this machine

```bash
cd ~/dotfiles
./install.sh
```

The script backs up existing targets with a timestamped `.bak.*` suffix, then creates symlinks into this repo.

### Restore on another Arch machine

1. Clone this repo to `~/dotfiles`
2. Run `./install.sh`
3. Restore packages from `packages/arch/`

Example:

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
xargs -r code --install-extension < packages/arch/vscode-extensions.txt
```

For Code - OSS:

```bash
xargs -r code-oss --install-extension < packages/arch/vscode-extensions.txt
```

Note: `nvim/` is not treated as a primary backup target here. The editor itself is based on LazyVim and can be rebuilt upstream; this repo only keeps local additions and lockfiles.

### Software inventory

`packages/arch/` stores snapshots of the current machine:

- `pacman-native.txt`: explicitly installed packages from official repos
- `pacman-foreign.txt`: explicitly installed AUR / foreign packages
- `vscode-extensions.txt`: VS Code / Code - OSS extensions
- `flatpak.txt`: Flatpak applications
- `generated-at.txt`: export time, host, and kernel

These files are snapshots only. They do not perform installation.

### Local-only secrets

Do not store machine-local secrets in this repo.

Use:

```bash
~/.zshrc.local
```

`zsh/.zshrc` sources it when present.
