-- 字符跳转。f+字符，是找字符本身。t+字符，是找字符和字符前面的一个字符。
-- s搜索字符，并自动排列搜索到的字符旁边的字母，方便按下跳转。
-- S搜索空格（应该）。
-- r修改单个字符。
-- R修改当前位置的字符，并可以持续输入。
-- cs是删除，按下之后也会给一个可跳转的字母，按下之后就会从当前位置删到按下字母的位置。
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
