{ lib, pkgs, config, nixgl, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/qutebrowser.nix
    ../modules/xmonad.nix
    ../modules/mpv.nix
  ];

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

  nixpkgs.overlays =
  let
    makeNixGlWrappedOverlay = pkgs:
      final: prev: builtins.listToAttrs (
        map (pkg: { name = pkg; value = config.lib.nixGL.wrap prev.${pkg}; }) pkgs
      );
  in
  [
    (makeNixGlWrappedOverlay [
      "alacritty"
      "mpv"
      "firefox"
      "qutebrowser"
    ])
  ];

  alacritty.font = "Terminess Nerd Font Mono";
  alacritty.font-italic = "JetBrainsMono Nerd Font";
  alacritty.font-size = 9.0;
  alacritty.font-offset = -2;
  alacritty.glyph-offset = -1;
  programs.alacritty.settings.font.builtin_box_drawing = false;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    geeqie
    feh
    scrot
    imagemagick
    gnuplot
    xcolor

    kanata

    nerdfonts
  ];

  home.stateVersion = "24.11";
}
