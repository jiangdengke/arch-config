-- markdown预览
return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	keys = { { "<leader>m", "<cmd>MarkdownPreview<cr>", desc = "markdown预览" } },
	build = "cd app && yarn install",
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_auto_close = 0  -- 添加这行：关闭buffer时不关闭预览窗口
	end,
	ft = { "markdown" },
}
