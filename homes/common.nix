{ lib, pkgs, komar-nvim, nixpkgs-unstable, ... }: {
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "komar";
    homeDirectory = "/home/komar";
  };

  imports = [
    ./modules/tmux.nix
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pstree # required by PS1
    jq # required by PS1
    fzf
    bat

    komar-nvim.nvim

    alacritty

    unzip

    gnumake
    cmake
    gcc
    rustup
    bacon
  ];
}
