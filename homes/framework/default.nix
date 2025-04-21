{ lib, pkgs, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/chromium.nix
    ../modules/xmonad.nix
    ../modules/mpv.nix
  ];

  chromium.enable-vaapi-amd-features = true;

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
