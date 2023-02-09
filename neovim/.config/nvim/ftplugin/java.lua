local home = vim.env.HOME
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/eclipse/' .. project_name
local mason = home .. '/.local/share/nvim/mason'
local jdtls = mason .. '/packages/jdtls'

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local jdtls_capabilities = require 'jdtls'.extendedClientCapabilities

local config = {
  cmd = {
    home .. '/.jenv/versions/17.0/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx8g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(jdtls .. '/plugins/org.eclipse.equinox.launcher_*.jar', 1),
    '-configuration', jdtls .. '/config_mac',
    '-data', workspace_dir,
    '-javaagent:' .. jdtls .. '/lombok.jar'
  },
  root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),

  settings = {
    java = {
      signatureHelp = { enabled = true };
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-17',
            path = vim.env.HOME .. '/.jenv/versions/17.0',
            default = true
          },
          {
            name = 'JavaSE-1.8',
            path = vim.env.HOME .. '/.jenv/versions/1.8',
          }
        }
      }
    },
  },

  capabilities = vim.tbl_deep_extend("keep", capabilities, jdtls_capabilities),
  on_attach = function(client, bufnr)
    require 'common'.on_attach(client, bufnr)
    require('jdtls.setup').add_commands()
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  end
}

local bundles = {
  vim.fn.glob(mason .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1)
}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. '/packages/java-test/extension/server/*.jar', 1), "\n"))
config['init_options'] = {
  bundles = bundles;
}

require('jdtls').start_or_attach(config)
