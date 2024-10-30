vim = vim or {}

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

require("lazy").setup("plugins")

vim.cmd [[colorscheme moonfly]]
vim.cmd [[let g:wiki_root = "~/Desktop/wiki"]]

vim.keymap.set('n', '<leader>ss', '<cmd>lua require"spectre".toggle()<cr>', opts)

require 'fzf-lua'.register_ui_select()
vim.keymap.set("n", "<leader>t", require 'fzf-lua'.files, opts)
vim.keymap.set("n", "<leader>g", require 'fzf-lua'.live_grep, opts)
vim.keymap.set("n", "<leader>b", require 'fzf-lua'.buffers, opts)
vim.keymap.set("n", "<leader>m", require 'fzf-lua'.marks, opts)

require("mason").setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    -- Disable jdtls setup, is handled by nvim-jdtls
    ['jdtls'] = function() end
  }
})

local lspconfig = require 'lspconfig'

-- Set up nvim-cmp.
local cmp = require 'cmp'
vim.cmd([[set completeopt=menu,menuone,noselect]])

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'lazydev', group_index = 0 },
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'copilot' },
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
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua require"fzf-lua".lsp_definitions()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua require"fzf-lua".lsp_declarations()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua require"fzf-lua".lsp_implementations()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua require"fzf-lua".lsp_typedefs()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua require"fzf-lua".lsp_references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<leader>ca', '<cmd>lua require"fzf-lua".lsp_code_actions()<cr>', opts)
  end,
})

vim.keymap.set('n', '<leader>xx', '<cmd>lua require"fzf-lua".diagnostics_document()<cr>', opts)
vim.keymap.set('n', '<leader>xX', '<cmd>lua require"fzf-lua".diagnostics_workspace()<cr>', opts)

-- Add cmp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require 'cmp_nvim_lsp'.default_capabilities()
)

lspconfig.lua_ls.setup {}
lspconfig.ltex.setup {
  settings = {
    ltex = {
      language = "en-GB",
    },
  }
}
lspconfig.basedpyright.setup {}
lspconfig.marksman.setup {}
