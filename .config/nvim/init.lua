local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.termguicolors = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.conceallevel = 2

vim.o.ignorecase = true
vim.o.incsearch = false
vim.o.hlsearch = true
vim.o.updatetime = 300
vim.o.incsearch = false
vim.wo.signcolumn = "yes"
vim.cmd([[set mouse=]])

local opts = { silent = true, noremap = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<space>de", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "<space>we", vim.diagnostic.setqflist, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

require("lazy").setup({
  { "folke/neodev.nvim", opts = {} },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>t', builtin.find_files, {})
      vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>a', builtin.treesitter, {})
      vim.keymap.set('n', '<leader>k', ':Telescope grapple', {})

      require("telescope").setup {
        defaults = {
          path_display = { "smart" },
          preview = {
            filesize_limit = 1.0, -- MB
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim" -- add this value
          },
          mappings = {
            i = {
              ["<C-u>"] = false
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            hidden = true
          },
        }
      }

      require("telescope").load_extension("grapple")
    end
  },
  {
    "rebelot/kanagawa.nvim",
    event = "BufEnter",
    config = function()
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  {
    "lervag/wiki.vim",
    config = function()
      vim.cmd([[let g:wiki_root = '~/wiki']])
    end
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    ft = "markdown",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("markview").setup({
        modes = { "n", "no", "c" },

        hybrid_modes = { "n" },
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "c";
          end
        }
      })
    end
  },
  {
    "cbochs/grapple.nvim",
    opts = {
      scope = "git", -- also try out "git_branch"
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "<leader>m", "<cmd>Grapple toggle<cr>",         desc = "Grapple toggle tag" },
      { "<leader>k", "<cmd>Grapple toggle_tags<cr>",    desc = "Grapple toggle tags" },
      { "<leader>K", "<cmd>Grapple toggle_scopes<cr>",  desc = "Grapple toggle scopes" },
      { "<leader>j", "<cmd>Grapple cycle forward<cr>",  desc = "Grapple cycle forward" },
      { "<leader>J", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },
      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple select 1" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple select 2" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple select 3" },
      { "<leader>4", "<cmd>Grapple select index=3<cr>", desc = "Grapple select 4" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "UiEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        sections = {
          lualine_b = { "grapple" }
        }
      })
    end,
  },
  {
    'creativenull/efmls-configs-nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup()
    end,
  },
  "preservim/nerdcommenter",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({})
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup {}
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup({})
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        view = {
          adaptive_size = true,
        },
        update_focused_file = {
          enable = true,
        },
        diagnostics = {
          enable = true,
        },
      })
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "github/copilot.vim"
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({ zindex = 50 })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local nvim_lsp = require("lspconfig")
      local servers = {
        "pyright",
        "ts_ls",
        "gopls",
        "lua_ls",
        "solargraph",
        "zls",
        "clangd",
        "ltex",
        "rust_analyzer",
        "kotlin_language_server",
        "astro",
        "tailwindcss",
        "prismals",
        "rnix",
        "lemminx",
        "jsonls",
        "dockerls",
        "docker_compose_language_service",
        "r_language_server",
        "marksman",
        "elixirls",
        "efm"
      }
      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      for _, lsp in ipairs(servers) do
        local opts = {
          flags = {
            debounce_text_changes = 150,
          },
        }
        if lsp == "ltex" then
          opts.settings = {
            ltex = {
              language = "en-GB",
            },
          }
        elseif lsp == "lua_ls" then
          opts.settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          }
        elseif lsp == "gopls" then
          opts.settings = {
            gopls = {
              codelenses = {
                generate = true,
                gc_details = true,
                test = true,
                tidy = true,
              },
              analyses = {
                fieldalignment = true,
                unusedparams = true,
              },
              staticcheck = true,
              allExperiments = true,
            },
          }
        elseif lsp == "efm" then
          local eslint = require('efmls-configs.linters.eslint')
          local prettier = require('efmls-configs.formatters.prettier')
          local languages = {
            typescript = { prettier, eslint },
            javascript = { prettier, eslint },
            markdown = { prettier }
          }
          opts.init_options = { documentFormatting = true, documentRangeFormatting = true }
          opts.settings = {
            languages = languages
          }
          opts.filetypes = vim.tbl_keys(languages)
        end
        nvim_lsp[lsp].setup(opts)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions

          ---@diagnostic disable-next-line: redefined-local
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
  "mfussenegger/nvim-jdtls",
  "mfussenegger/nvim-dap",
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      vim.cmd([[set completeopt=menu,menuone,noselect]])

      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 64,
            mode = "symbol_text",
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            },
          }),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
})
