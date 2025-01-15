local options = {
  backup = false,                          -- 创建备份文件
  clipboard = "unnamedplus",               -- 允许 Neovim 访问系统剪贴板
  cmdheight = 2,                           -- 为显示消息在 Neovim 命令行中保留更多空间
  completeopt = { "menuone", "noselect" }, -- 主要用于 cmp 插件
  conceallevel = 0,                        -- 使 Markdown 文件中的 `` 可见
  fileencoding = "utf-8",                  -- 写入文件时使用的编码
  hlsearch = true,                         -- 高亮显示所有匹配的搜索模式
  ignorecase = true,                       -- 在搜索模式中忽略大小写
  mouse = "a",                             -- 允许在 Neovim 中使用鼠标
  pumheight = 10,                          -- 弹出菜单的高度
  showmode = false,                        -- 不需要显示诸如 -- INSERT -- 之类的信息
  showtabline = 2,                         -- 始终显示标签页
  smartcase = true,                        -- 智能大小写
  smartindent = true,                      -- 使缩进更加智能
  splitbelow = true,                       -- 强制所有水平分割在当前窗口下方
  splitright = true,                       -- 强制所有垂直分割在当前窗口右侧
  swapfile = false,                        -- 不创建交换文件
  -- termguicolors = true,                   -- 设置终端 GUI 颜色（大多数终端支持此项）
  timeoutlen = 300,                        -- 等待映射序列完成的时间（以毫秒为单位）
  undofile = true,                         -- 启用持久化撤销
  updatetime = 300,                        -- 更快的完成时间（默认 4000ms）
  writebackup = false,                     -- 如果文件被另一个程序编辑（或在编辑时被另一个程序写入文件），则不允许编辑
  expandtab = true,                        -- 将制表符转换为空格
  shiftwidth = 2,                          -- 每次缩进插入的空格数
  tabstop = 2,                             -- 插入 2 个空格作为制表符
  cursorline = true,                       -- 高亮显示当前行
  number = true,                           -- 显示行号
  relativenumber = false,                  -- 不显示相对行号
  numberwidth = 4,                         -- 设置行号列的宽度为 4（默认值）
  
  signcolumn = "yes",                      -- 始终显示标记列，否则每次都会移动文本
  wrap = true,                             -- 将行显示为一行长行
  linebreak = true,                        -- 配合 wrap 使用，不拆分单词
  scrolloff = 8,                           -- 光标上方和下方保持的最小屏幕行数
  sidescrolloff = 8,                       -- 如果 wrap 为 `false`，则光标两侧保持的最小屏幕列数
  guifont = "monospace:h17",               -- 图形化 Neovim 应用程序中使用的字体
  whichwrap = "bs<>[]hl",                  -- 允许哪些“水平”键移动到上一行/下一行
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.opt.shortmess = "ilmnrx"                        -- 缩短 Vim 消息的标志，参见 :help 'shortmess'
vim.opt.shortmess:append "c"                           -- 不显示 |ins-completion-menu| 消息
vim.opt.iskeyword:append "-"                           -- 搜索时识别带连字符的单词
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- 在使用 'textwidth' 自动换行注释、在插入模式下按 <Enter> 或在普通模式下按 'o' 或 'O' 时，不自动插入当前注释标记
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- 将 Vim 插件与 Neovim 分开，以防 Vim 仍在使用
