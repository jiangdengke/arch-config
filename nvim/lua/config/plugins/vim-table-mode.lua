-- vim 表格插件，也可渲染markdown
return {
	"dhruvasagar/vim-table-mode",
	config = function()
		-- Table Mode 插件配置
		vim.g.table_mode_corner = "|" -- 设置表格边界符为 '|'
		vim.g.table_mode_corner = "+" -- 设置表格边界符为 '|'
		vim.g.table_mode_auto = 1 -- 启用自动模式
		vim.g.table_mode_align = 1 -- 启用表格自动对齐

		-- 可选：快捷键设置
		vim.api.nvim_set_keymap("n", "<Leader>tm", ":TableModeToggle<CR>", { noremap = true, silent = true })
	end,
	keys = {
		{ "<Leader>tm", "<cmd>TableModeToggle<CR>", desc = "vim-table-mode：格式化表格" },
	},
	ft = { "markdown" }, -- 仅在 Markdown 文件中加载该插件
}
