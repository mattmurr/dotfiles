return {
  {
    "williamboman/mason.nvim",
    opts = { registries = { "github:nvim-java/mason-registry", "github:mason-org/mason-registry" } }
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  { "mfussenegger/nvim-jdtls", lazy = true },
  {
    "JavaHello/spring-boot.nvim",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
      "ibhagwan/fzf-lua",        -- 可选
    },
    opts = function()
      local mason_registry = require("mason-registry")
      local ls_path = mason_registry.get_package("spring-boot-tools"):get_install_path() .. "/extension/language-server"
      local home = vim.env.HOME
      return {
        ls_path = ls_path,
        exploded_ls_jar_data = true,
        java_cmd = home .. '/.jenv/versions/21.0/bin/java',
        log_file = home .. '/.local/state/nvim/spring-boot-ls.log'
      }
    end
  }
}
