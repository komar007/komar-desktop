{ config, pkgs, nixos-hardware, nixpkgs-unstable, ...}: {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-13-7040-amd

    ../modules/xserver.nix
    ../modules/audio.nix
    ../modules/splashscreen.nix
  ];

  services.libinput.touchpad.disableWhileTyping = true;

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "hibernate";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=3600
  '';

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
