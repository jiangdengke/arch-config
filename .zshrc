
# ------------------------------------------------------------
# 如果启用了 Powerlevel10k 的 instant prompt，可以将下列代码取消注释，
# 并将其置于 ~/.zshrc 文件顶部，以便在初始化过程中尽早加载。
#（注意：涉及密码提示或确认的初始化代码需要放在这之前）
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# conda
# export PATH="/opt/anaconda/bin:$PATH"
# eval "$(/opt/anaconda/bin/conda shell.zsh hook)"
# 定义 fzf 预览函数
fzf_preview() {
  local selected
  # 使用 fd 命令生成当前目录下的文件列表,并传递给 fzf
  selected=$(fd | fzf --preview 'bat --style=numbers --color=always --line-range=:500 {}' \
                     --bind 'enter:accept' \
                     --layout=reverse \
                     --info=inline \
                     --height=40% \
                     --preview-window=right:50%:wrap) && {
    if [[ -n "$selected" ]]; then
      # 使用 vim 打开选中的文件
      vim "$selected"
    fi
  }
}

# 使用 zle 创建一个 widget
fzf_key_bind_widget() {
  zle -I
  fzf_preview
}

zle -N fzf_key_bind_widget

# 绑定 '\' 键到 fzf_key_bind_widget
bindkey '\\' fzf_key_bind_widget
# ------------------------------------------------------------
# 初始化 vfox
eval "$(vfox activate zsh)"

# ------------------------------------------------------------
# 初始化 starship（一个跨 shell 的提示符工具）
eval "$(starship init zsh)"

# ------------------------------------------------------------

# ------------------------------------------------------------
# 初始化 zoxide（增强目录跳转工具）
eval "$(zoxide init zsh)"

# ------------------------------------------------------------
# 配置 yazi 工具
# 定义一个函数 y()，它先创建一个临时文件，再调用 yazi 命令，
# yazi 命令执行完毕后，将临时文件中存储的目录路径读取出来，
# 如果此路径存在且不同于当前目录，就切换到该目录，最后删除临时文件。
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ------------------------------------------------------------
# 指定 oh-my-zsh 的安装路径
ZSH=/usr/share/oh-my-zsh/

# ------------------------------------------------------------
# 加载 Powerlevel10k 主题
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# ------------------------------------------------------------
# 定义 oh-my-zsh 插件列表（这里包含了一些常用的插件，如 git、sudo、自动颜色支持、命令自动提示和语法高亮）
plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting )
source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------
# 当输入的命令不存在时，调用这个函数
# 它会先提示找不到该命令，接着使用 pacman 的文件查询功能（pacman -F）尝试查找包含此命令的包，
# 并以彩色格式输出相关包信息（注意：输出格式中使用了颜色转义码）。
function command_not_found_handler {
	local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
	printf 'zsh: command not found: %s\n' "$1"
	local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
	if (( ${#entries[@]} )) ; then
		printf "${bright}$1${reset} may be found in the following packages:\n"
		local pkg
		for entry in "${entries[@]}" ; do
			local fields=( ${(0)entry} )
			if [[ "$pkg" != "${fields[2]}" ]]; then
				printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
			fi
			printf '    /%s\n' "${fields[4]}"
			pkg="${fields[2]}"
		done
	fi
	return 127
}

# ------------------------------------------------------------
# 检测系统中是否安装了 yay 或 paru（常见的 AUR 辅助工具），
# 并把检测到的工具赋值给变量 aurhelper 用于后续对 AUR 包的操作
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

# ------------------------------------------------------------
# 定义一个 in 函数，用于自动安装包，
# 根据传入的包名，先判断包是否在官方仓库中（pacman -Si），
# 将其分为 arch（官方包）或 aur（AUR 包），然后执行相应安装命令
function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# ------------------------------------------------------------
# 定义一些有用的别名
alias f='fastfetch'
# 设置 nvim 别名为 n，这样输入 n 就会启动 nvim 编辑器
alias n='nvim'
# 清屏
alias c='clear'

# 使用 eza（一个 ls 的增强版）显示长列表，图标自动显示
alias l='eza -lh --icons=auto'

# 使用 eza 显示单列列表
alias ls='eza -1 --icons=auto'

# 使用 eza 显示详细的文件和目录（包含隐藏文件、图标、排序以及目录优先）
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'

# 使用 eza 显示仅目录的列表
alias ld='eza -lhD --icons=auto'

# 使用 eza 以树状结构显示文件夹
alias lt='eza --icons=auto --tree'

# 对 AUR 包的卸载（使用 aurhelper）
alias un='$aurhelper -Rns'

# 更新系统及包（使用 aurhelper，其实同时更新官方仓库和 AUR）
alias up='$aurhelper -Syu'

# 列出已安装的包（使用 aurhelper）
alias pl='$aurhelper -Qs'

# 搜索可用包（使用 aurhelper）
alias pa='$aurhelper -Ss'

# 清理 AUR 的缓存（使用 aurhelper）
alias pc='$aurhelper -Sc'

# 移除无用的依赖包
alias po='$aurhelper -Qtdq | $aurhelper -Rns -'

# 启动 GUI 版 Visual Studio Code（假设 code 对应执行命令）
alias vc='code'

# ------------------------------------------------------------
# 定义一些目录导航的快捷命令
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# ------------------------------------------------------------
# 修改 mkdir 的默认行为，加上 -p 参数，可以同时创建多级目录，
# 即使目标目录已经存在也不会报错
alias mkdir='mkdir -p'

# ------------------------------------------------------------
# 加载个性化的 powerlevel10k 配置，如果 ~/.p10k.zsh 文件存在就加载它
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------------------------------------
# 显示 Pokemon（通过 pokemon-colorscripts 工具展示带颜色的 Pokemon）
pokemon-colorscripts --no-title -r 1,3,6

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jdk/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jdk/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jdk/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jdk/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

