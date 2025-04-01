{ lib, pkgs, komar-nvim, nixpkgs-unstable, ... }: {
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "komar";
    homeDirectory = "/home/komar";
  };

  home.packages = with pkgs; [
    pstree # required by PS1
    jq # required by PS1
    fzf
    tmux

    komar-nvim.nvim

    xmonad-with-packages
    pulsemixer
    alacritty
    xsel
    dzen2
    xmobar
    htop

    unzip

    gnumake
    cmake
    gcc
    rustup
  ];
}
