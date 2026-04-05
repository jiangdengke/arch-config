# Arch Software Backup

[English](README.en.md)

这里保存的是当前 Arch 机器的软件清单快照。

## 文件说明

- `arch/pacman-native.txt`：官方仓库里显式安装的包
- `arch/pacman-foreign.txt`：AUR / foreign 包
- `arch/flatpak.txt`：Flatpak 应用，如果存在

## 在另一台机器上恢复

```bash
sudo pacman -S --needed - < arch/pacman-native.txt
paru -S --needed - < arch/pacman-foreign.txt
```

## 这里没覆盖的内容

- systemd 服务和 timer 启用状态
- 浏览器状态和应用数据
- 机器私有密钥和 token
- 任何不通过 pacman / paru / flatpak 管理的软件
