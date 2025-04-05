{ lib, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in
{
  programs.firefox.enable = true;
  programs.firefox.profiles."default-release" = {
    id = 0;
    path = "default";
    isDefault = true;

    settings = {
      "extensions.autoDisableScopes" = 0;
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
    extensions = with firefox-addons; [
      firenvim
      ublock-origin
    ];
  };
}
