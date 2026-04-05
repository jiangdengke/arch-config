-- 这是 Yazi 的初始化文件。
-- 这里只保留最小初始化逻辑，避免 debug 时提示缺少 init.lua。

-- 启用 Git 状态插件，并把它排在较靠后的位置显示。
require("git"):setup({
  order = 1500,
})
