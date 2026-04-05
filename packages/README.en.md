# Arch Software Backup

[中文](README.md)

These files are snapshots of the current Arch machine's software inventory.

## Files

- `arch/pacman-native.txt`: explicitly installed packages from official repos
- `arch/pacman-foreign.txt`: explicitly installed AUR / foreign packages
- `arch/flatpak.txt`: Flatpak applications, if present

## Restore

```bash
sudo pacman -S --needed - < arch/pacman-native.txt
paru -S --needed - < arch/pacman-foreign.txt
```

## Not captured here

- enabled systemd services and timers
- browser state and app data
- machine-local secrets
- anything installed outside pacman / paru / flatpak
