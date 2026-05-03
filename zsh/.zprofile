# 在 zsh 登录 shell 中兼容读取通用的 `~/.profile`。
if [[ -f "$HOME/.profile" ]]; then
  source "$HOME/.profile"
fi

# 登录 shell 兜底输入法环境。图形应用优先读取 environment.d。
export XMODIFIERS='@im=fcitx'
export QT_IM_MODULE='fcitx'
export SDL_IM_MODULE='fcitx'
