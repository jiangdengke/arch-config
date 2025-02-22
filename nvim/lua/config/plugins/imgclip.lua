-- 获取当前文件名
local filename = vim.fn.expand("%:t")
-- 删除扩展,并添加连加符号`.`
filename = string.gsub(filename, "%..*", "") .. "."

return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	config = function()
    -- 图片粘贴快捷键
    vim.api.nvim_set_keymap("n", "<C-p>", ":PasteImage<CR>", { noremap = false, silent = true })
		require'img-clip'.setup {
			default = {
				dir_path = filename .. "assets", -- 图片保存路径：./文件名.assets
				insert_mode_after_paste = false, -- 粘贴图片后不进入插入模式
			},
			filetypes = {
				markdown = {
					url_encode_path = true, ---@type boolean
					template = "![$FILE_NAME_NO_EXT]($FILE_PATH)", -- 图片模板，中括号提示包含文件名
					download_images = false, ---@type boolean
				},
			},
		}
	end
}
