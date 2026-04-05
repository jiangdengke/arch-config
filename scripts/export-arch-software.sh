#!/usr/bin/env zsh
set -euo pipefail

script_path="${0:A}"
repo_root="$(cd "$(dirname "${script_path}")/.." && pwd)"
out_dir="${repo_root}/packages/arch"

mkdir -p "${out_dir}"

pacman -Qqen | sort > "${out_dir}/pacman-native.txt"
pacman -Qqem | sort > "${out_dir}/pacman-foreign.txt"

if command -v code >/dev/null 2>&1; then
  code --list-extensions | sort > "${out_dir}/vscode-extensions.txt"
elif command -v code-oss >/dev/null 2>&1; then
  code-oss --list-extensions | sort > "${out_dir}/vscode-extensions.txt"
fi

if command -v flatpak >/dev/null 2>&1; then
  flatpak list --app --columns=application | sort > "${out_dir}/flatpak.txt"
fi

cat > "${out_dir}/generated-at.txt" <<EOF
Generated: $(date -Iseconds)
Host: $(uname -n)
Kernel: $(uname -r)
EOF
