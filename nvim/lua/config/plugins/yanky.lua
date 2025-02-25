-- 改变nvim的yank和put功能
return{
  "gbprod/yanky.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" }
  },
  opts = {
    ring = { storage = "sqlite" },
  },
  keys = {
    { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "打开复制历史" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "复制文本" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "将复制的文本放到光标之后" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "将复制的文本放到光标之前" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "将复制的文本放到选择内容之后" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "将复制的文本放到选择内容之前" },
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "通过复制历史选择上一个条目" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "通过复制历史选择下一个条目" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "在光标后粘贴并缩进（按行）" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "在光标前粘贴并缩进（按行）" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "在光标后粘贴并缩进（按行）" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "在光标前粘贴并缩进（按行）" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "粘贴并向右缩进" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "粘贴并向左缩进" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "在之前粘贴并向右缩进" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "在之前粘贴并向左缩进" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "应用过滤器后粘贴" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "应用过滤器之前粘贴" },
  },
}
