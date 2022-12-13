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

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup {
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
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        auto_install = true,
        highlight = {
          enable = true,
        },
      }
    end
  }

  use {
    'williamboman/mason-lspconfig.nvim',
    requires = 'williamboman/mason.nvim',
  }

  use {
    'neovim/nvim-lspconfig', -- Configurations for Nvim LSP
    after = { 'telescope.nvim', 'mason.nvim', 'mason-lspconfig.nvim', 'cmp-nvim-lsp' },
    config = function()
      require 'mason'.setup()
      require 'mason-lspconfig'.setup {
        automatic_installation = true,
        ensure_installed = { "jdtls" }
      }
      local servers = {
        'gopls',
        'tsserver',
        'sumneko_lua',
        'pyright',
        'astro',
        'ltex',
        'eslint',
        'cssls',
        'html',
        'jsonls',
        'ccls',
        'rust_analyzer'
      }

      local default_lspopts = {
        on_attach = require 'common'.on_attach,
        -- Add additional capabilities supported by nvim-cmp
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      }

      for _, lsp in ipairs(servers) do
        local lspopts = default_lspopts
        if lsp == 'sumneko_lua' then
          lspopts.settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
              },
            },
          }
        elseif lsp == 'ltex' then
          lspopts.settings = {
            ltex = {
              language = "en-GB"
            }
          }
        end
        require 'lspconfig'[lsp].setup(lspopts)
      end
    end
  }

  use {
    'j-hui/fidget.nvim',
    config = function()
      require "fidget".setup {}
    end
  }

  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use {
    'hrsh7th/nvim-cmp',
    requires = { 'LuaSnip' },
    config = function()

      -- luasnip setup
      local luasnip = require 'luasnip'

      -- nvim-cmp setup
      local cmp = require 'cmp'
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' }
        },
      }

    end
  }

  use 'preservim/nerdcommenter'
  use {
    'mickael-menu/zk-nvim',
    config = function()
      require 'zk'.setup {
        picker = "telescope",
        lsp = {
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          }
        }
      }
    end
  }


  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope-ui-select.nvim'
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = 'nvim-lua/plenary.nvim',
    after = { 'telescope-fzf-native.nvim', 'telescope-ui-select.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          path_display = { "smart" },
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-h>"] = actions.select_horizontal
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      }

      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>t', require 'telescope.builtin'.find_files, opts)
      vim.keymap.set('n', '<leader>g', require 'telescope.builtin'.live_grep, opts)
      vim.keymap.set('n', '<leader>b', require 'telescope.builtin'.buffers, opts)
      vim.keymap.set('n', '<leader>h', require 'telescope.builtin'.help_tags, opts)

    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = true
      })
    end
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.prettierd,
          require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.diagnostics.markdownlint,
        }
      })
    end
  }

  use 'mfussenegger/nvim-jdtls'

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true
      }
    end
  }

  use {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup()
      vim.cmd("colorscheme kanagawa")
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup({
        options = {
          disabled_filetypes = { "NvimTree" },
        }
      })
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
