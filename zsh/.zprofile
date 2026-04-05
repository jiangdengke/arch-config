# 在 zsh 登录 shell 中兼容读取通用的 `~/.profile`。
if [[ -f "$HOME/.profile" ]]; then
  source "$HOME/.profile"
fi
