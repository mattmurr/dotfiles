{
  description = "dotfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations."Matthews-MacBook-Air" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # nix-darwin
        ({ pkgs, ... }: {
          nix.extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
          '';
          services.nix-daemon.enable = true;
          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToControl = true;
          system.defaults.dock.autohide = true;
          system.defaults.finder.AppleShowAllExtensions = true;
          system.defaults.finder._FXShowPosixPathInTitle = true;
          security.pam.enableSudoTouchIdAuth = true;
          fonts.fontDir.enable = true;
          fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
          programs.zsh.enable = true;
          environment.shells = [ pkgs.zsh ];
          environment.loginShell = pkgs.zsh;

          system.stateVersion = 4;
        })

        # home-manager
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.matt.imports = [
              ({ config, pkgs, lib, ... }: {
                home.stateVersion = "22.11";
                home.packages = [
                  pkgs.git
                  pkgs.ripgrep
                  pkgs.fd
                  pkgs.curlie
                ];
                home.sessionVariables = {
                  EDITOR = "nvim";
                };
                programs.git = {
                  enable = true;
                  extraConfig = builtins.readFile ./git/.gitconfig;
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
                  enableSyntaxHighlighting = true;
                  shellAliases = {
                    curl = "curlie";
                    ls = "ls --color=auto -F";
                  };
                  initExtra = ''
                    bindkey -v
                    export KEYTIMEOUT=1

                    export FZF_DEFAULT_COMMAND="fd -t f --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
                    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
                    export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
                    export FZF_DEFAULT_OPTS="--height 100% --layout=reverse --border --ansi"
                    export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"

                  '';
                };
                programs.direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                  enableZshIntegration = true;
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
                    rnix-lsp
                    sumneko-lua-language-server
                    # NOTE: https://github.com/eclipse/eclipse.jdt.ls/pull/2258
                    (jdt-language-server.overrideAttrs (oldAttrs: {
                      src = fetchurl {
                        url = "https://download.eclipse.org/jdtls/milestones/1.19.0/jdt-language-server-1.19.0-202301171536.tar.gz";
                        sha256 = "sha256-9rreuMw2pODzOVX5PBmUZoV5ixUDilQyTsrnyCQ+IHs=";
                      };
                    }))
                  ];
                  plugins = with pkgs.vimPlugins; [
                    nvim-treesitter.withAllGrammars
                    gruvbox-nvim
                    fzf-vim
                    nvim-lspconfig
                    null-ls-nvim
                    nvim-jdtls
                    lsp_signature-nvim
                    gitsigns-nvim
                    vim-sleuth
                    fidget-nvim
                    todo-comments-nvim
                    nvim-tree-lua
                    nerdcommenter
                    zk-nvim
                    indent-blankline-nvim
                  ];
                };
                xdg.configFile.nvim = {
                  source = ./neovim;
                  recursive = true;
                };
                xdg.configFile."nvim/ftplugin/java.lua".text = ''
                  local capabilities = require 'jdtls'.extendedClientCapabilities

                  local jdtls_cmd = require('lspconfig')['jdtls'].document_config.default_config.cmd
                  jdtls_cmd[1] = "jdt-language-server"

                  local config = {
                    cmd = jdtls_cmd,
                    root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),

                    settings = {
                      java = {
                        signatureHelp = { enabled = true };
                        configuration = {
                          runtimes = {
                            {
                              name = 'JavaSE-1.8',
                              path = '${pkgs.openjdk8.home}',
                            }
                          }
                        }
                      },
                    },

                    init_options = {
                      bundles = {}
                    },

                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      require 'common'.on_attach(client, bufnr)
                      require('jdtls.setup').add_commands()
                    end
                  }

                  require('jdtls').start_or_attach(config)
                '';
              })
            ];
          };
        }
      ];
    };
  };
}
