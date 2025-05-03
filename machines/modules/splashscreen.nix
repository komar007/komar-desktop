{ config, pkgs, nixpkgs-unstable, ...}: {
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  # quiet boot...
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "boot.shell_on_fail"
  ];
}
