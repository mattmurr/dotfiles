local home = os.getenv('HOME')
local root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1])
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local jdk17_home = home .. "/.jenv/versions/17.0"
local jdk8_home = home .. "/.jenv/versions/1.8"
local jdtls_dir = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'

local capabilities = require 'jdtls'.extendedClientCapabilities
capabilities = vim.tbl_extend('keep', capabilities, require("cmp_nvim_lsp").default_capabilities())

local config = {
  cmd = {
    jdk17_home .. "/bin/java",
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', jdtls_dir .. '/config_mac',
    '-data', workspace_folder,
  },
  root_dir = root_dir,

  settings = {
    java = {
      signatureHelp = { enabled = true };
      contentProvider = { preferred = 'fernflower' };
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = jdk8_home,
          },
          {
            name = "JavaSE-17",
            path = jdk17_home
          }
        }
      }
    },
  },

  init_options = {
    bundles = {},
    extendedClientCapabilities = {
      progressReportProvider = false,
    },
  },

  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require 'common'.on_attach(client, bufnr)
    require('jdtls.setup').add_commands()
  end
}

require('jdtls').start_or_attach(config)
