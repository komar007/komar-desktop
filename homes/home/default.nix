{ lib, pkgs, komar-nvim, ... }: {
  imports = [
    ../modules/firefox.nix
  ];

  home.packages = with pkgs; [
    mpv
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
