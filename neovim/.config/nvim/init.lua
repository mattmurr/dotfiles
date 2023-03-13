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
    'mattmurr/vim-colors-synthetic',
    config = function()
      vim.cmd[[
        colorscheme synthetic
      ]]
    end
  }
  use {
    'mickael-menu/zk-nvim',
    config = function()
      require 'zk'.setup {
        picker = 'telescope',
        lsp = {
          config = {
            cmd = { 'zk', 'lsp' },
            name = 'zk',
            on_attach = require'common'.on_attach,
          },
          auto_attach = {
            enabled = true,
            filetypes = { 'markdown' }
          }
        }
      }
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
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>t', builtin.find_files, {})
      vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>b', builtin.buffers, {})
      vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>q', builtin.quickfix, {})

      local actions = require('telescope.actions')
      require 'telescope'.setup {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-h>"] = actions.select_horizontal,
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
            "--trim" -- add this value
          }
        },
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            path_display = { "shorten" }
          },
        }
      }

      local function multiopen(prompt_bufnr, method)
        local edit_file_cmd_map = {
          vertical = "vsplit",
          horizontal = "split",
          tab = "tabedit",
          default = "edit",
        }
        local edit_buf_cmd_map = {
          vertical = "vert sbuffer",
          horizontal = "sbuffer",
          tab = "tab sbuffer",
          default = "buffer",
        }
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selection = picker:get_multi_selection()

        if #multi_selection > 1 then
          require("telescope.pickers").on_close_prompt(prompt_bufnr)
          pcall(vim.api.nvim_set_current_win, picker.original_win_id)

          for i, entry in ipairs(multi_selection) do
            local filename, row, col

            if entry.path or entry.filename then
              filename = entry.path or entry.filename

              row = entry.row or entry.lnum
              col = vim.F.if_nil(entry.col, 1)
            elseif not entry.bufnr then
              local value = entry.value
              if not value then
                return
              end

              if type(value) == "table" then
                value = entry.display
              end

              local sections = vim.split(value, ":")

              filename = sections[1]
              row = tonumber(sections[2])
              col = tonumber(sections[3])
            end

            local entry_bufnr = entry.bufnr

            if entry_bufnr then
              if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
                vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
              end
              local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
              pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
            else
              local command = i == 1 and "edit" or edit_file_cmd_map[method]
              if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
                filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
                pcall(vim.cmd, string.format("%s %s", command, filename))
              end
            end

            if row and col then
              pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
            end
          end
        else
          actions["select_" .. method](prompt_bufnr)
        end
      end
    end
  }
  use {
    'akinsho/bufferline.nvim', tag = "v3.*",
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup {
        options = {
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end
        }
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
