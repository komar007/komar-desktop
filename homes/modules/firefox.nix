{ lib, pkgs, ... }: {
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
