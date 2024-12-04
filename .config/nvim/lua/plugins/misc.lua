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
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' can be specified
      });
    end
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     update_focused_file = {
  --       enable = true
  --     }
  --   }
  -- },
  -- {
  --   {
  --     "antosha417/nvim-lsp-file-operations",
  --     dependencies = {
  --       "nvim-lua/plenary.nvim",
  --       -- Uncomment whichever supported plugin(s) you use
  --       "nvim-tree/nvim-tree.lua",
  --       -- "nvim-neo-tree/neo-tree.nvim",
  --       -- "simonmclean/triptych.nvim"
  --     },
  --     config = function()
  --       require("lsp-file-operations").setup()
  --     end,
  --   },
  -- },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "kelly-lin/ranger.nvim",
    opts = { replace_netrw = true, ui = { width = 0.75, height = 0.75, border = "rounded" } },
    config = function(_, opts)
      require("ranger-nvim").setup(opts)
      vim.api.nvim_set_keymap("n", "<leader>-", "", {
        noremap = true,
        callback = function()
          require("ranger-nvim").open(true)
        end,
      })
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  }
}
