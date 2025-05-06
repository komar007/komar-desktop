{ lib, pkgs, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/chromium.nix
    ../modules/xmonad.nix
    ../modules/mpv.nix
  ];

  home.pointerCursor.size = 32;

  chromium.enable-vaapi-amd-features = true;

  xdg.default-browser-app = "firefox.desktop";

  alacritty.font = "JetBrainsMono Nerd Font";
  alacritty.font-size = 7.0;

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
