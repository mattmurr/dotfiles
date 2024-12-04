return {
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      opts = {
        ['suggestion.enabled'] = false,
        ['panel.enabled'] = false,
      }
    },
    opts = {}
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",       -- Only on MacOS or Linux
    opts = {},
    -- See Commands section for default commands if you want to lazy load on them
  }
}
