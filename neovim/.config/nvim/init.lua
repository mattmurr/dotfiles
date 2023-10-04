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
		"nvim-lualine/lualine.nvim",
		event = "UiEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				sections = {
					lualine_x = { "aerial" },

					-- Or you can customize it
					lualine_y = {
						{
							"aerial",
							-- The separator to be used to separate symbols in status line.
							sep = " ) ",

							-- The number of symbols to render top-down. In order to render only 'N' last
							-- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
							-- be used in order to render only current symbol.
							depth = nil,

							-- When 'dense' mode is on, icons are not rendered near their symbols. Only
							-- a single icon that represents the kind of current symbol is rendered at
							-- the beginning of status line.
							dense = false,

							-- The separator to be used to separate symbols in dense mode.
							dense_sep = ".",

							-- Color the symbol icons.
							colored = true,
						},
					},
				},
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					-- default options: exact mode, multi window, all directions, with a backdrop
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
		},
	},
	{
		"RRethy/nvim-base16",
		config = function()
			vim.cmd("colorscheme base16-da-one-black")
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		lazy = true,
		event = { "BufReadPre " .. vim.fn.expand("~") .. "/Obsidian/Brain2/**.md" },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			dir = "~/Obsidian/Brain2",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependences = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				theme = "base16",
			})
		end,
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
			require("barbecue").setup({
				theme = "tokyonight",
			})
		end,
	},
	"preservim/nerdcommenter",
	"tpope/vim-sleuth",
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = false,
			})
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
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require("ibl").setup({})
		end,
	},
	{
		"junegunn/fzf.vim",
		dependencies = {
			"junegunn/fzf",
		},
		config = function()
			vim.keymap.set("n", "<leader>t", ":Files<cr>", opts)
			vim.keymap.set("n", "<leader>g", ":Rg<cr>", opts)
			vim.keymap.set("n", "<leader>b", ":Buffers<cr>", opts)
		end,
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
			-- You probably also want to set a keymap to toggle aerial
			vim.keymap.set("n", "<leader>a", "<cmd>call aerial#fzf()<cr>")
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
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup({ zindex = 50 })
		end,
	},
	{
		"mhartington/formatter.nvim",
		config = function()
			-- Utilities for creating configurations
			local util = require("formatter.util")

			-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
			require("formatter").setup({
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.WARN,
				-- All formatter configurations are opt-in
				filetype = {
					python = {
						require("formatter.filetypes.python").black,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					java = {
						require("formatter.filetypes.java").clangformat,
					},
					-- Use the special "*" filetype for defining formatter configurations on
					-- any filetype
					["*"] = {
						-- "formatter.filetypes.any" defines default configurations for any
						-- filetype
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})

			vim.keymap.set("n", "<leader>f", "<cmd> :Format<CR>", opts)
			vim.keymap.set("n", "<leader>F", "<cmd> :FormatWrite<CR>", opts)
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
				"ruff_lsp",
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
				elseif lsp == "ruff-lsp" then
					opts.on_attach = function(client, bufnr)
						client.server_capabilities.hoverProvider = false
					end
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
					--vim.keymap.set('n', '<space>f', function()
					--vim.lsp.buf.format { async = true }
					--end, opts)
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
