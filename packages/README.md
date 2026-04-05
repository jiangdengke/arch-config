# Arch Software Backup

These files are generated snapshots of the current Arch machine's software inventory.

## Files

- `arch/pacman-native.txt`: explicitly installed packages from official repos
- `arch/pacman-foreign.txt`: explicitly installed AUR/foreign packages
- `arch/vscode-extensions.txt`: VS Code / Code - OSS extensions
- `arch/flatpak.txt`: Flatpak app IDs, if Flatpak is installed
- `arch/generated-at.txt`: export time, host and kernel

## Refresh

Run:

```bash
./scripts/export-arch-software.sh
```

This script only exports software lists. It does not install or remove anything.

## Restore

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
xargs -r code --install-extension < packages/arch/vscode-extensions.txt
```

If you use Code - OSS instead of VS Code:

```bash
xargs -r code-oss --install-extension < packages/arch/vscode-extensions.txt
```

## Not captured here

- enabled services and timers
- browser state and app data
- machine-local secrets
- anything installed outside pacman/paru/flatpak/code
