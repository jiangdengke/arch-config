-- 在编辑器顶部添加一个可视化的标签栏。比如文件保没保存
return {
	"akinsho/bufferline.nvim",
	version = "*", -- 安装最新的稳定版
	dependencies = "kyazdani42/nvim-web-devicons",
	config = function()
		require("bufferline").setup({})
	end,
}
