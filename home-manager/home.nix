{ lib, pkgs, system, komar-nvim, ... }:
let
  komar = komar-nvim.packages.${system};
in
{
  nixpkgs = {
    config.allowUnfree = true;
  };

  home = {
    username = "komar";
    homeDirectory = "/home/komar";

    packages = with pkgs; [
      pstree # required by PS1
      jq # required by PS1
      fzf
      tmux

      komar.nvim

      xmonad-with-packages
      pulsemixer
      alacritty
      xsel
      dzen2
      xmobar
      htop

      unzip

      gnumake
      cmake
      gcc
      rustup

      mpv
      geeqie
      feh
      scrot
      imagemagick
      gnuplot
      xcolor

      super-slicer-beta

      davinci-resolve
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

    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build. Don't ask questions.
    stateVersion = "23.11";
  };

  programs.firefox = {
    enable = true;
    profiles."default-release" = {
      id = 0;
      path = "default";
      isDefault = true;

      search.engines."Nix Packages" = {
        definedAliases = [ "@np" ];
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      };
      search.engines."Nix Options" = {
        definedAliases = [ "@no" ];
        urls = [{
          template = "https://search.nixos.org/options";
          params = [
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
      };
    };
  };
}
