return {
	'akinsho/bufferline.nvim',
	version = "*",-- 安装最新的稳定版
	dependencies = 'kyazdani42/nvim-web-devicons',
	config = function()
		require("bufferline").setup {}
	end
}
