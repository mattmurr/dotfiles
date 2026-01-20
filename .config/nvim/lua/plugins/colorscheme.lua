return {
  --{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ... },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        section_separators   = { left = '', right = '' }
      }
    }
  }
}
