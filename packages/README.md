# Arch Software Backup

## 中文说明

这里保存的是当前 Arch 机器的软件清单快照。

### 文件说明

- `arch/pacman-native.txt`：官方仓库里显式安装的包
- `arch/pacman-foreign.txt`：AUR / foreign 包
- `arch/vscode-extensions.txt`：VS Code / Code - OSS 扩展
- `arch/flatpak.txt`：Flatpak 应用
- `arch/generated-at.txt`：导出时间、主机名、内核版本

### 在另一台机器上恢复

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
xargs -r code --install-extension < packages/arch/vscode-extensions.txt
```

如果使用 Code - OSS：

```bash
xargs -r code-oss --install-extension < packages/arch/vscode-extensions.txt
```

### 这里没覆盖的内容

- systemd 服务和 timer 启用状态
- 浏览器状态和应用数据
- 机器私有密钥和 token
- 任何不通过 pacman / paru / flatpak / code 管理的软件

## English

These files are snapshots of the current Arch machine's software inventory.

### Files

- `arch/pacman-native.txt`: explicitly installed packages from official repos
- `arch/pacman-foreign.txt`: explicitly installed AUR / foreign packages
- `arch/vscode-extensions.txt`: VS Code / Code - OSS extensions
- `arch/flatpak.txt`: Flatpak applications
- `arch/generated-at.txt`: export time, host, and kernel

### Restore

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
xargs -r code --install-extension < packages/arch/vscode-extensions.txt
```

For Code - OSS:

```bash
xargs -r code-oss --install-extension < packages/arch/vscode-extensions.txt
```

### Not captured here

- enabled systemd services and timers
- browser state and app data
- machine-local secrets
- anything installed outside pacman / paru / flatpak / code
