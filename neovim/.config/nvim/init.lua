require'plugins'

vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.updatetime = 300
vim.o.incsearch = false
vim.wo.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.cmd [[
set mouse=
set completeopt-=preview

sign define DiagnosticSignError text= linehl= texthl=DiagnosticSignError numhl=
sign define DiagnosticSignWarn text= linehl= texthl=DiagnosticSignWarn numhl=
sign define DiagnosticSignInfo text= linehl= texthl=DiagnosticSignInfo numhl=
sign define DiagnosticSignHint text=💡 linehl= texthl=DiagnosticSignHint numhl=
]]

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

