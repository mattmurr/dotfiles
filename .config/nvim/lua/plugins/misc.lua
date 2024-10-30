return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      { path = "wezterm-types",      mods = { "wezterm" } }
    },
  },
  { "Bilal2453/luvit-meta",        lazy = true },
  { "justinsgithub/wezterm-types", lazy = true },

  'nvim-pack/nvim-spectre',

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  }
}
