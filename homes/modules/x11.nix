{ lib, pkgs, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "DMZ-Black";
    size = 32;
    package = pkgs.vanilla-dmz;
  };
}
