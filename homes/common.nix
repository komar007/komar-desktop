{ lib, pkgs, nvim-module, nixpkgs-unstable, ... }: {
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "komar";
    homeDirectory = "/home/komar";
  };

  imports = [
    ./modules/x11.nix
    ./modules/xdg.nix
    nvim-module
    ./modules/tmux
    ./modules/alacritty.nix
    ./modules/starship
    ./modules/git
    ./modules/tig
  ];

  dot-tmux.session-shells = {
    btop = "exec btop";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pstree # required by PS1
    jq # required by PS1
    fzf
    bat

    unzip

    gnumake
    cmake
    gcc
    rustup
    bacon

    btop

    nerd-fonts.terminess-ttf
    nerd-fonts.jetbrains-mono
  ];
}
