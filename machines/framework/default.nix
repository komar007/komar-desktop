{ lib, config, pkgs, nixos-hardware, nixpkgs-kernel-good-hibernate, ...}: {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
    ../modules/grub2.nix
    ../modules/splashscreen.nix

    ../modules/brightness
    ../modules/xserver.nix
    ../modules/amd.nix
    ../modules/audio.nix
  ];

  boot.loader.grub2-theme.customResolution = "2256x1504";

  # workaround something wrong in linux-6.6.92 which causes hibernate to wake up to blank screen
  boot.kernelPackages = nixpkgs-kernel-good-hibernate.linuxKernel.packages.linux_6_6;

  services.libinput.touchpad.disableWhileTyping = true;
  services.libinput.touchpad.accelSpeed = "0.7";

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "hibernate";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
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
