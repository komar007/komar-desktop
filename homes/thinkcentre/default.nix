{ lib, pkgs, ... }: {
  imports = [
    ../modules/firefox.nix
    ../modules/xmonad.nix
    ../modules/mpv.nix
  ];

  alacritty.font = "JetBrainsMono Nerd Font";
  alacritty.font-size = 9.0;

  home.packages = with pkgs; [
    geeqie
    feh
    scrot
    imagemagick
    gnuplot
    xcolor

    super-slicer-beta

    #davinci-resolve
    exiftool
    blender
    gimp
    unetbootin
    spotifyd

    dosbox
    wine
    (jazz2.overrideAttrs (finalAttrs: previousAttrs: {
      version = "3.0.0";
      src = fetchFromGitHub {
        owner = "deathkiller";
        repo = "jazz2-native";
        rev = finalAttrs.version;
        hash = "sha256-t1bXREL/WWnYnSfCyAY5tus/Bq5V4HVHg9s7oltGoIg=";
      };
    }))
    calibre
  ];

  home.stateVersion = "23.11";
}
