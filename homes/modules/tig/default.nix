{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    tig
  ];

  home.file.".config/tig/config".text = builtins.readFile ./tigrc;
}
