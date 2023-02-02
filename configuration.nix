{ pkgs, ... }: {
  nix.package = pkgs.nixVersions.stable;
  nixpkgs.config.allowUnfree = true;
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
}

