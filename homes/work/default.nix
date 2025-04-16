{ lib, pkgs, config, nixgl, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/qutebrowser.nix
    ../modules/xmonad.nix
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

  home.packages = with pkgs; [
    mpv
    geeqie
    feh
    scrot
    imagemagick
    gnuplot
    xcolor

    kanata
  ];

  home.stateVersion = "24.11";
}
