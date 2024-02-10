({ config, pkgs, lib, ... }: {
  home.stateVersion = "22.11";
  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.curlie
    pkgs.github-cli
    pkgs.nodejs
    pkgs.colima
    pkgs.docker-credential-helpers
    pkgs.docker
    pkgs.lazygit
    pkgs.kubectl
    pkgs.consul
    pkgs.htop
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  programs.git = {
    enable = true;
  };
  home.file.".gitignore_global".source = ./git/.gitignore_global;
  programs.bat.enable = true;
  programs.fzf = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      curl = "curlie";
      ls = "ls --color=auto -F";
      cat = "bat --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub)";
    };
    initExtra = ''
      bindkey -v
      export KEYTIMEOUT=1

      export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      export EDITOR="nvim"

      export FZF_DEFAULT_COMMAND="fd -t f --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
      export FZF_DEFAULT_OPTS="--height 100% --layout=reverse --border --ansi"
      export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "tmux"
      ];
      extraConfig = ''
        zstyle ':bracketed-paste-magic' active-widgets '.self-*'
        ZSH_TMUX_AUTOSTART=true
      '';
    };
  };
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux/.tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.fzf-tmux-url
      {
        plugin = tmuxPlugins.tmux-fzf;
        extraConfig = "TMUX_FZF_OPTIONS=\"-p -w 80% -h 80% -m\"";
      }
      {
        plugin = tmuxPlugins.fuzzback;
        extraConfig = ''
          set -g @fuzzback-popup 1
          set -g @fuzzback-finder-layout 'reverse'
          set -g @fuzzback-popup-size '80%'
        '';
      }
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };
  home.file.".prettierrc".source = ./misc/.prettierrc;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
    extraPackages = with pkgs; [
      tree-sitter
      gopls
      rust-analyzer
      nodePackages.pyright
      nodePackages.typescript
      nodePackages.typescript-language-server
      sumneko-lua-language-server
      jdt-language-server
      nixd
    ];
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      gruvbox-nvim
      fzf-vim
      nvim-lspconfig
      nvim-jdtls
      lsp_signature-nvim
      gitsigns-nvim
      vim-sleuth
      fidget-nvim
      todo-comments-nvim
      nerdcommenter
      indent-blankline-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      lspkind-nvim
      oil-nvim
      nvim-navic
      nvim-web-devicons
      barbecue-nvim
    ];
  };
  xdg.configFile.nvim = {
    source = ./neovim;
    recursive = true;
  };
  xdg.configFile."nvim/ftplugin/java.lua".text = ''
local home = vim.env.HOME
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/eclipse/' .. project_name
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local jdtls_capabilities = require 'jdtls'.extendedClientCapabilities

local config = {
  cmd = { '${pkgs.jdt-language-server}/bin/jdtls', '-javaagent:' .. '${pkgs.lombok}/share/java/lombok.jar=ECJ' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {
      signatureHelp = { enabled = true };
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-17',
            path = '${pkgs.jdk17}',
          },
          {
            name = 'JavaSE-1.8',
            path = '${pkgs.jdk8}',
          },
          {
            name = 'JavaSE-21',
            path = '${pkgs.jdk21}',
            default = true
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

  capabilities = vim.tbl_deep_extend("keep", capabilities, jdtls_capabilities)
}
-- Disable echo for loading, we use fidget.nvim
config.handlers = {['language/status'] = function() end}

require('jdtls').start_or_attach(config)
require('jdtls.setup').add_commands()
  '';
})
