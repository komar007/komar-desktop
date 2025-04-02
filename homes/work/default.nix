{ lib, pkgs, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/xmonad.nix
  ];

  home.packages = with pkgs; [
    mpv
    geeqie
    feh
    scrot
    imagemagick
    gnuplot
    xcolor
  ];

  home.stateVersion = "24.11";
}
