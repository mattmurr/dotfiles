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
set completeopt=menu,menuone,noselect
]]

vim.cmd [[ 
sign define DiagnosticSignError text= linehl= texthl=DiagnosticSignError numhl= 
sign define DiagnosticSignWarn text= linehl= texthl=DiagnosticSignWarn numhl= 
sign define DiagnosticSignInfo text= linehl= texthl=DiagnosticSignInfo numhl= 
sign define DiagnosticSignHint text=💡 linehl= texthl=DiagnosticSignHint numhl= 
]]

vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

local keyopts = { silent = true, noremap = true }
vim.keymap.set("n", "<leader>t", "<cmd>Files<cr>", keyopts)
vim.keymap.set("n", "<leader>g", "<cmd>Rg<cr>", keyopts)
vim.keymap.set("n", "<leader>b", "<cmd>Buffers<cr>", keyopts)
vim.keymap.set("n", "<leader>x", "<cmd>Commands<cr>", keyopts)


require('orgmode').setup_ts_grammar()

require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true;
    additional_vim_regex_highlighting = { 'org' },
    disable = { "help" }
  }
}

require 'orgmode'.setup {
  org_agenda_files = { '~/Sync/org/*' },
  org_default_notes_file = '~/Sync/org/refile.org'
}


local nvim_lsp = require("lspconfig")
local servers = {
  "pyright",
  "tsserver",
  "gopls",
  "sumneko_lua",
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

require('lsp_signature').setup({
  zindex = 50
})

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.prettierd,
    require("null-ls").builtins.diagnostics.markdownlint,
  }
})

require('gitsigns').setup({
  current_line_blame = false
})

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

require("todo-comments").setup {}

require "fidget".setup {}

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true
}

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
    { name = 'orgmode' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    --{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
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

vim.cmd [[
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
]]
