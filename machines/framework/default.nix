{ config, pkgs, nixos-hardware, nixpkgs-unstable, komar-nvim, ...}: {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-13-7040-amd

    ../modules/hibernate-while-in-suspend.nix
    ../modules/xserver.nix
    ../modules/audio.nix
  ];

  services.logind.lidSwitch = "suspend";
  hibernate-while-in-suspend.seconds = 3600;
  hibernate-while-in-suspend.ac-online-file = "/sys/class/power_supply/ACAD/online";

  networking = {
    hostName = "nixos-frmwrk";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.fwupd.enable = true;

  services.udisks2.enable = true;

  services.printing.enable = true;

  services.openssh.enable = true;

  services.lighttpd = {
    enable = true;
    document-root = "/var/www";
  };

  system.stateVersion = "24.11";
}
