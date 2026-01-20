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
    ft = "java, yaml, jproperties",
    dependencies = {
      "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
      "ibhagwan/fzf-lua",        -- 可选
    },
    opts = {}
  }
}
