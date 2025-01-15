-- 获取 Neovim 内置的 `fn` 模块，方便后续调用 Vim 函数
local fn = vim.fn

-- 自动安装 packer.nvim 插件管理器
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  -- 如果 packer.nvim 未安装，则通过 git 克隆到指定目录
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1", -- 仅克隆最近一次提交，减少下载量
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  -- 提示用户安装完成后需要关闭并重新打开 Neovim
  print("Installing packer... 请关闭并重新打开 Neovim 以完成安装.")
  -- 加载 packer.nvim 插件
  vim.cmd([[packadd packer.nvim]])
end

-- 设置自动命令，当保存 plugins.lua 文件时自动重新加载配置并同步插件
vim.cmd([[
  augroup packer_user_config
    autocmd! 
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- 尝试安全地加载 packer.nvim，避免因插件未安装而导致错误
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return -- 如果加载失败，则终止后续配置
end

-- 配置 packer.nvim 使用浮动窗口显示（带有圆角边框）
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
      -- 使用浮动窗口显示插件安装界面，边框样式为圆角
    end,
  },
})

-- 定义要安装和管理的插件列表
return packer.startup(function(use)
  -- packer 可以管理自身，用于自动更新
  use "wbthomason/packer.nvim"

  -- 提供 Popup API 的实现，许多插件依赖它
  use "nvim-lua/popup.nvim"

  -- 提供许多实用的 Lua 函数，许多插件依赖它
  use "nvim-lua/plenary.nvim"

  -- 在首次安装 packer.nvim 后，自动同步安装插件
  if PACKER_BOOTSTRAP then
    require("packer").sync()
    -- 如果是第一次安装 packer.nvim，运行同步命令安装所有插件
  end
end)
