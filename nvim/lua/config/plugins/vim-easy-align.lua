-- vim对齐插件
return{
  "junegunn/vim-easy-align",
  config = function()
    -- 设置快捷键
    vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
    vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })

    -- 配置对齐分隔符
    vim.g.EasyAlign_delimiters = {
      ['='] = { pattern = '=', and_space = true },
      [','] = { pattern = ',', and_space = true },
      [';'] = { pattern = ';', and_space = true },
      ['->'] = { pattern = '->', and_space = false },
    }

    -- 预设对齐选项
    vim.g.EasyAlign_presets = {
      ['n'] = {
        { pattern = '->', opts = { delimiter = '->', align = 'left' } },
      },
    }
  end,
}
