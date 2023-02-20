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
vim.cmd [[
set mouse=
]]

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
    'Mofiqul/vscode.nvim',
    config = function()
      vim.cmd [[
        set background=dark
      ]]
      require'vscode'.setup{}
    end
  }
  use 'preservim/nerdcommenter'
  use 'tpope/vim-sleuth'
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf' },
    config = function()
      local opts = { silent = true, noremap = true }
      vim.keymap.set("n", "<leader>t", "<cmd>Files<cr>", opts)
      vim.keymap.set("n", "<leader>g", "<cmd>Rg<cr>", opts)
      vim.keymap.set("n", "<leader>b", "<cmd>Buffers<cr>", opts)
      vim.keymap.set("n", "<leader>x", "<cmd>Commands<cr>", opts)
    end
  }
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
    'nvim-tree/nvim-tree.lua',
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require 'nvim-tree'.setup {
        open_on_setup = false,
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
          nls.builtins.diagnostics.markdownlint,
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
        'rnix'
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
        elseif lsp == "sumneko_lua" then
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
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      vim.cmd [[set completeopt=menu,menuone,noselect]]

      local cmp = require 'cmp'

      cmp.setup({
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
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
