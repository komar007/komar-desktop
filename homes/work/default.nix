{ lib, pkgs, config, nixgl, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/xmonad.nix
  ];

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  nixpkgs.overlays = [
    (final: prev: {
      alacritty = config.lib.nixGL.wrap prev.alacritty;
      mpv = config.lib.nixGL.wrap prev.mpv;
      firefox = config.lib.nixGL.wrap prev.firefox;
    })
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
