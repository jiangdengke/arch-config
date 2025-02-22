vim.g.mapleader = " "

local keymap = vim.keymap

-- ---------- 插入模式 ---------- ---

-- ---------- 视觉模式 ---------- ---
-- 单行或多行移动
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ---------- 正常模式 ---------- ---
-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口 
keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口
-- 保存退出
keymap.set("n", "<leader>wq", ":wq<CR>") -- 保存退出
keymap.set("n", "<leader>qq", ":q!<CR>") -- 退出不保存
keymap.set("n", "<leader>w", ":w<CR>") -- 退出不保存
-- 移动
keymap.set("n", "J", "5j") -- 退出不保存
keymap.set("n", "K", "5k") -- 退出不保存
-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")
-- markdown
keymap.set("n", "<leader>m", ":MarkdownPreview<CR>")

keymap.set("n", "<leader>c", ":bd<CR>")
keymap.set("n", "<leader>la", ":Lazy<CR>")
-- 切换buffer
keymap.set("n", "<C-L>", ":bnext<CR>")
keymap.set("n", "<C-H>", ":bprevious<CR>")

-- ---------- 插件 ---------- ---
-- Neo-tree
keymap.set("n", "<leader>e", ":Neotree<CR>")
