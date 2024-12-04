return {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  {
    "L3MON4D3/LuaSnip",
    dependencies = {"rafamadriz/friendly-snippets"},
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
  "saadparwaiz1/cmp_luasnip",
  "onsails/lspkind.nvim"
}
