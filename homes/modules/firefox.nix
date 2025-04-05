{ lib, pkgs, ... }:
let
  # stuff coming
in
{
  programs.firefox.enable = true;
  programs.firefox.profiles."default-release" = {
    id = 0;
    path = "default";
    isDefault = true;

    settings = {
      "ui.key.menuAccessKeyFocuses" = false;
    };

    search.force = true;
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
}
