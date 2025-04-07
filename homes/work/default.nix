{ lib, pkgs, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/xmonad.nix
  ];

  nixpkgs.overlays = let
    wrapWith = wrapper: pkg: pkgs.writeShellApplication {
      name = "${pkg.meta.mainProgram}";
      text = ''${pkgs.lib.getExe wrapper} ${pkgs.lib.getExe pkg} "$@"'';
    };
    nixGlIntelize = wrapWith pkgs.nixgl.nixGLIntel;
  in [
    (final: prev: {
      # TODO: why does config.lib.nixGL.wrap cause infinite recursion in overlay?
      alacritty = nixGlIntelize prev.alacritty;
      mpv = nixGlIntelize prev.mpv;
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
