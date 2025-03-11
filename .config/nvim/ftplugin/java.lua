local home = vim.env.HOME
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/eclipse/' .. project_name
local mason = home .. '/.local/share/nvim/mason'
local jdtls = mason .. '/packages/jdtls'
local lombok = jdtls .. '/lombok.jar'

local capabilities = require'jdtls'.extendedClientCapabilities

local spring_path = require("mason-registry")
    .get_package("spring-boot-tools")
     :get_install_path() .. "/extension/jars/*.jar"
local spring = vim.split(vim.fn.glob(spring_path), "\n", {})

local config = {
  cmd = {
    home .. '/.jenv/versions/21.0/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms2g',
    '-Xmx8g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. lombok .. '=ECJ',
    '-jar', vim.fn.glob(jdtls .. '/plugins/org.eclipse.equinox.launcher_*.jar', 1),
    '-configuration', jdtls .. '/config_mac',
    '-data', workspace_dir
  },
  root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {
      signatureHelp = { enabled = true };
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-21',
            path = vim.env.HOME .. '/.jenv/versions/21.0',
            default = true
          },
          {
            name = 'JavaSE-17',
            path = vim.env.HOME .. '/.jenv/versions/17.0'
          },
          {
            name = 'JavaSE-11',
            path = vim.env.HOME .. '/.jenv/versions/11.0',
          },
          {
            name = 'JavaSE-1.8',
            path = vim.env.HOME .. '/.jenv/versions/1.8',
          }
        }
      },
      format = {
        settings = {
          url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml',
          profile = 'GoogleStyle'
        }
      }
    },
  },
  capabilities = capabilities,
  init_options = {
    bundles = spring
  }
}
-- Disable echo for loading, we use fidget.nvim
config.handlers = {['language/status'] = function() end}

require('jdtls').start_or_attach(config)
require('jdtls.setup').add_commands()
