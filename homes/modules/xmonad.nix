{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    xmonad-with-packages
    pulsemixer
    xsel
    dzen2
    xmobar
    htop
  ];
}
