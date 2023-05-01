vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.o.ignorecase = true
vim.o.incsearch = false
vim.o.hlsearch = true
vim.o.updatetime = 300
vim.o.incsearch = false
vim.wo.signcolumn = 'yes'
vim.cmd [[set mouse=]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = { "help" }
        }
      }
    end
  }
  use {
    "sainnhe/gruvbox-material",
    config = function()
      vim.o.background = "dark"
      vim.cmd [[colorscheme gruvbox-material]]
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {}
    end
  }
  use 'preservim/nerdcommenter'
  use 'tpope/vim-sleuth'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require 'gitsigns'.setup {
        current_line_blame = false
      }
    end
  }
  use {
    'folke/todo-comments.nvim',
    config = function()
      require 'todo-comments'.setup {}
    end
  }
  use {
    'j-hui/fidget.nvim',
    config = function()
      require 'fidget'.setup {}
    end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require 'indent_blankline'.setup {
        show_current_context = true,
        show_current_context_start = true
      }
    end
  }
  use {
    'ThePrimeagen/harpoon',
    config = function()
      require("harpoon").setup {}
      vim.keymap.set('n', 'mff', require('harpoon.mark').add_file, {})
      vim.keymap.set('n', 'mfu', require('harpoon.mark').rm_file, {})
    end
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>t', builtin.find_files, {})
      vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>q', builtin.quickfix, {})
      vim.keymap.set('n', '<leader>m', ':Telescope harpoon marks<cr>', {})

      local actions = require('telescope.actions')
      require 'telescope'.setup {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-h>"] = actions.select_vertical,
              ["<C-u>"] = false
            }
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim"
          },
          path_display = { "truncate" }
        },
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
          },
        }
      }
      require("telescope").load_extension('harpoon')
    end
  }
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }
  use {
    'nvim-tree/nvim-tree.lua',
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require 'nvim-tree'.setup {
        view = {
          adaptive_size = true
        },
        update_focused_file = {
          enable = true
        },
        diagnostics = {
          enable = true
        }
      }

    end
  }
  use {
    'ray-x/lsp_signature.nvim',
    config = function()
      require 'lsp_signature'.setup { zindex = 50 }
    end
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local nls = require 'null-ls'
      nls.setup {
        sources = {
          nls.builtins.formatting.prettierd,
          nls.builtins.diagnostics.markdownlint
        }
      }
    end
  }
  use {
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local nvim_lsp = require("lspconfig")
      local servers = {
        "pyright",
        "tsserver",
        "gopls",
        "lua_ls",
        "solargraph",
        "zls",
        "clangd",
        "ltex",
        "rust_analyzer",
        "kotlin_language_server",
        "astro",
        'tailwindcss',
        'prismals',
        'rnix',
        'lemminx',
        'jsonls',
        'dockerls',
        'docker_compose_language_service'
      }
      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      for _, lsp in ipairs(servers) do
        local opts = {
          on_attach = require('common').on_attach,
          flags = {
            debounce_text_changes = 150,
          },
        }
        if lsp == "tsserver" then
          opts.on_attach = function(client, bufnr)
            client.server_capabilities.document_formatting = false
            client.server_capabilities.document_Range_formatting = false
            require('common').on_attach(client, bufnr)
          end
        elseif lsp == "ltex" then
          opts.settings = {
            ltex = {
              language = "en-GB",
            },
          }
        elseif lsp == "lua_ls" then
          opts.settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' }
              }
            }
          }
        elseif lsp == 'gopls' then
          opts.settings = {
            gopls = {
              codelenses = {
                generate = true,
                gc_details = true,
                test = true,
                tidy = true
              },
              analyses = {
                fieldalignment = true,
                unusedparams = true
              },
              staticcheck = true,
              allExperiments = true
            }
          }
        end
        nvim_lsp[lsp].setup(opts)
      end

    end
  }
  use 'mfussenegger/nvim-jdtls'
  use 'mfussenegger/nvim-dap'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim'
    },
    config = function()
      vim.cmd [[set completeopt=menu,menuone,noselect]]

      local cmp = require 'cmp'
      local lspkind = require 'lspkind'

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format {
            maxwidth = 64,
            mode = "symbol_text",
            menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            })
          }
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

local opts = { silent = true, noremap = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>de', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>we', vim.diagnostic.setqflist, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])
