{ config, pkgs, nixpkgs-unstable, komar-nvim, ...}: {
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    xkb = {
      layout = "pl";
    };
  };
}
