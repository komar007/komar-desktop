{ lib, pkgs, nvim-module, tmux-module, tmux-alacritty-module, nixpkgs-unstable, ... }: {
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "komar";
    homeDirectory = "/home/komar";
  };

  imports = [
    ./modules/x11.nix
    ./modules/xdg.nix
    nvim-module
    tmux-module
    tmux-alacritty-module
    ./modules/alacritty.nix
    ./modules/git
    ./modules/tig
  ];

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
  ];
}
