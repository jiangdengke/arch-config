-- 格式化工具
return {
	"stevearc/conform.nvim",
	-- 从mason中加载格式化器
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = { "ConformInfo" }, -- 使用命令时加载
	keys = {
		-- 添加格式化快捷键
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "格式化文件",
		},
	},
	-- 主要配置
	opts = {
		-- 配置格式化器
		formatters_by_ft = {
			lua = { "stylua" },
			toml = { "taplo" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},

		-- 保存时自动格式化
		-- format_on_save = {
		-- 	timeout_ms = 500,
		-- 	lsp_fallback = true,
		-- 	async = false,
		-- },

		-- 格式化器配置
		formatters = {
			-- 这里可以自定义每个格式化器的配置
			prettier = {
				-- 优先使用项目局部配置
				prepend_args = { "--config-precedence", "prefer-file" },
			},
		},

		-- 默认格式化配置
		default_format_opts = {
			timeout_ms = 1000,
			quiet = false,
			lsp_format = "fallback",
		},

		-- 日志等级
		log_level = vim.log.levels.ERROR,

		-- 通知设置
		notify_on_error = true,
		notify_no_formatters = true,
	},
	init = function()
		-- 可以在这里添加自动命令
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
