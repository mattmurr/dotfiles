vim = vim or {}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- vim.cmd [[colorscheme moonfly]]
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
vim.cmd [[let g:wiki_root = "~/wiki"]]

require 'fzf-lua'.register_ui_select()
vim.keymap.set("n", "<leader>t", require 'fzf-lua'.files, opts)
vim.keymap.set("n", "<leader>g", require 'fzf-lua'.live_grep, opts)
vim.keymap.set("n", "<leader>b", require 'fzf-lua'.buffers, opts)
vim.keymap.set("n", "<leader>m", require 'fzf-lua'.marks, opts)

require("mason").setup()

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

-- vim.g.spring_boot = {
--   jdt_extensions_jars = {
--     "io.projectreactor.reactor-core.jar",
--     "org.reactivestreams.reactive-streams.jar",
--     "jdt-ls-commons.jar",
--     "jdt-ls-extension.jar",
--   },
-- }

require('spring_boot').init_lsp_commands()

vim.lsp.config['ltex'] = {
  settings = {
    ltex = {
      language = "en-GB",
    },
  }
}
vim.lsp.enable({
  'lua_ls',
  'ltex',
  'basedpyright',
  'marksman',
  'lenninx'
})

