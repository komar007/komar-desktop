{ lib, pkgs, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/xmonad.nix
    ../modules/mpv.nix
  ];

  home.packages = with pkgs; [
    geeqie
    feh
    scrot
    imagemagick
    gnuplot
    xcolor

    exiftool
  ];

  home.stateVersion = "24.11";
}
