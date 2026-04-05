# Arch Software Backup

Use these files to rebuild most of the user-facing software stack on another Arch machine.

Files:

- `arch/pacman-native.txt`: explicitly installed packages from official repos
- `arch/pacman-foreign.txt`: explicitly installed foreign/AUR packages
- `arch/vscode-extensions.txt`: VS Code / Code - OSS extensions
- `arch/flatpak.txt`: Flatpak app IDs, if Flatpak is installed

Refresh the lists on the current machine:

```bash
./scripts/export-arch-software.sh
```

Restore on another Arch machine:

```bash
sudo pacman -S --needed - < packages/arch/pacman-native.txt
paru -S --needed - < packages/arch/pacman-foreign.txt
code --install-extension $(cat packages/arch/vscode-extensions.txt)
```

This does not capture everything. You still need:

- enabled services and timers
- browser state and app data
- machine-local secrets
- any packages installed outside pacman/paru/flatpak/code
