return  {
    "williamboman/mason-lspconfig.nvim",
    requires = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "marksman" },
        ensure_installed = { "pyright" }, 
      })
    end,
}
