local opt = vim.opt
-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
-- 防止包裹
opt.wrap = true

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
-- 命令模式显示补全菜单
vim.o.wildmenu = true
-- 100毫秒没有输入文件将会自动保存交换文件
vim.o.updatetime = 100
-- 打开文件时进入上次编辑的位置
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])
-- fcitx5在normal模式时自动切换为英文输入法,摘自fcitx5的archwiki
vim.cmd([[
autocmd InsertLeave * :silent !fcitx5-remote -c
autocmd BufCreate *  :silent !fcitx5-remote -c 
autocmd BufEnter *  :silent !fcitx5-remote -c 
autocmd BufLeave *  :silent !fcitx5-remote -c
]])
-- vim.cmd[[colorscheme tokyonight-night]]
vim.cmd[[colorscheme onedark]]
