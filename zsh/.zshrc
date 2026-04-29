# 把 `vim` 命令指向 `nvim`。
alias vim='nvim'

# 默认编辑器。
export EDITOR="nvim"

# 图形界面程序优先使用的编辑器。
export VISUAL="$EDITOR"

# Yazi 包装函数：退出文件管理器后，把当前 shell 目录同步到最后停留目录。
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Zim Framework 自动生成配置的开始标记。{{{
#
# 这部分会被交互式 shell 读取，用于初始化 Zim 和相关模块。
#

# ---------------
# Zsh 基础配置
# ---------------

#
# 历史记录
#

# 如果命令重复，只保留较新的那条历史记录。
setopt HIST_IGNORE_ALL_DUPS

#
# 输入与编辑行为
#

# 使用 Emacs 风格按键；如果想改成 Vi 模式可换成 `bindkey -v`。
bindkey -e

# 对命令名启用拼写纠正提示，当前未启用。
#setopt CORRECT

# 自定义拼写纠正提示文案，当前未启用。
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# 把 `/` 从单词字符集合里移除，便于按单词删除或跳转路径。
WORDCHARS=${WORDCHARS//[\/]}

# ----------------
# 模块相关配置
# ----------------

#
# git 模块
#

# 给自动生成的 git 别名设置自定义前缀；默认前缀是 `G`，当前未启用。
#zstyle ':zim:git' aliases-prefix 'g'

#
# input 模块
#

# 连续输入 `...` 时自动展开为 `../../` 一类路径，当前未启用。
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle 模块
#

# 自定义终端标题格式；如果不设置，默认是 `%n@%m: %~`，当前未启用。
# 语法说明见 http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions 模块
#

# 禁止每次 `precmd` 自动重新绑定 widget；当 autosuggestions 在 `~/.zimrc` 最后加载时能提升性能。
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# 自定义自动建议的显示样式，当前未启用。
# 说明见 https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting 模块
#

# 指定启用哪些高亮器。
# 说明见 https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# 自定义主高亮器样式，当前未启用。
# 说明见 https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# --------------
# 初始化模块
# --------------

# Zim 安装目录。
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# 如果缺少 `zimfw.zsh`，就自动下载插件管理器。
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# 如果缺少 `init.zsh` 或 `.zimrc` 更新过，就重新生成初始化文件并补齐缺失模块。
if [[ -e ${ZIM_HOME}/zimfw.zsh && ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# 只有初始化脚本生成成功时才加载，避免新机器首次启动时直接报错。
if [[ -r ${ZIM_HOME}/init.zsh ]]; then
  source ${ZIM_HOME}/init.zsh
fi

# }}} Zim Framework 自动生成配置的结束标记。

# 把用户本地工具和 Flutter SDK 加进 PATH。
export PATH="$HOME/.local/bin:$HOME/dev/flutter/bin:$PATH"


# ===== Clash / flclash 终端代理（HTTP）=====
# flclash 本机代理地址。
export PROXY_HOST="127.0.0.1"

# flclash 本机代理端口。
export PROXY_PORT="7890"

# 开启终端代理环境变量。
proxyon() {
  export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
  export https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
  export HTTP_PROXY="$http_proxy"
  export HTTPS_PROXY="$https_proxy"

  export no_proxy="localhost,127.0.0.1,::1"
  export NO_PROXY="$no_proxy"

  echo "Proxy ON  -> ${http_proxy}"
}

# 清理终端代理环境变量。
proxyoff() {
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY
  echo "Proxy OFF"
}

# 打印当前代理变量，并测试访问 GitHub。
proxytest() {
  echo "http_proxy=$http_proxy"
  echo "https_proxy=$https_proxy"
  curl -I https://github.com 2>/dev/null | head -n 1
}
# ==========================================

# 读取仅本机使用的私有配置和敏感信息覆盖项。
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
export PATH="$HOME/.local/bin:$PATH"
