return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      ['suggestion.enabled'] = false,
      ['panel.enabled'] = false,
      ['telemetry.telemetryLevel'] = 'off',
      logger = {
				file_log_level = vim.log.levels.TRACE,
			},
    }
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require"codecompanion".setup {
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
      }
    end
  },
}
