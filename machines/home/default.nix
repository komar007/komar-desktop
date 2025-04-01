{ config, pkgs, nixpkgs-unstable, komar-nvim, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  systemd =
    let
      reconnect-bt = pkgs.writeShellScriptBin "reconnect-bt" ''
        BT="${pkgs.bluez}/bin/bluetoothctl"
        for _ in $(seq 10); do
          if [ "$("$BT" list | wc -l)" -gt 0 ]; then
            for dev in $("$BT" devices Trusted | cut -d' ' -f2); do
              "$BT" -t1 connect "$dev"
            done
            echo "attempted to reconnect trusted bluetooth devices"
            exit
          fi
          sleep 1
        done
        echo "failed to reconnect trusted bluetooth devices, no controller"
      '';
    in
    {
      user.services.connect-bt = {
        description = "Connect trusted Bluetooth devices";
        wantedBy = [ "pipewire.service" ];
        after = [ "pipewire.service" ];
        serviceConfig.Type = "oneshot";
        script = "${pkgs.lib.getExe reconnect-bt}";
      };
      services.reconnect-bt = {
        description = "Reconnect trusted Bluetooth devices";
        wantedBy = [ "post-resume.target" ];
        after = [ "post-resume.target" ];
        serviceConfig.Type = "oneshot";
        script = "${pkgs.lib.getExe reconnect-bt}";
      };
    };


  networking = {
    hostName = "nixos-home";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.udisks2.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
    displayManager.startx.enable = true;
    xkb = {
      layout = "pl";
    };
  };
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-sdk
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    extraConfig.pipewire-pulse."10-auto-connect" = {
      "pulse.cmd" = [
        { cmd = "load-module"; args = "module-switch-on-connect"; }
      ];
    };
  };

  services.openssh.enable = true;

  services.lighttpd = {
    enable = true;
    document-root = "/var/www";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
