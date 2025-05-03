{ lib, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  home-assistant = firefox-addons.buildFirefoxXpiAddon {
    pname = "home-assistant";
    version = "0.5.0";
    addonId = "home-assistant@bokub.dev";
    url = "https://addons.mozilla.org/firefox/downloads/file/4239570/home_assistant-0.5.0.xpi";
    sha256 = "sha256-Jb6Xqh7Qd/BDokLTRdMVH71pEbOL6Hr/v9n8jX0lm2M=";
    meta = with lib; {
      homepage = "https://github.com/bokub/home-assistant-extension#readme";
      description = "";
      license = licenses.mit;
      mozPermissions = [];
      platforms = platforms.all;
    };
  };
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
      "browser.aboutConfig.showWarning" = false;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
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
    search.engines."Home Manager Options" = {
      definedAliases = [ "@hmo" ];
      urls = [{
        template = "https://home-manager-options.extranix.com/";
        params = [
          { name = "query"; value = "{searchTerms}"; }
          { name = "release"; value = "release-24.11"; }
        ];
      }];
    };
    search.engines."crates.io" = {
      definedAliases = [ "@c" ];
      urls = [{
        template = "https://crates.io/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
        ];
      }];
    };
    extensions = with firefox-addons; [
      firenvim
      ublock-origin
      home-assistant
    ];
  };
}
