{ config, pkgs, nixpkgs-unstable, komar-nvim, system, ...}:
let
  unstable = nixpkgs-unstable.legacyPackages.${system};
in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.overlays = [
    #(import ./tmux-override.nix)
  ];

  system.replaceDependencies.replacements = [{
    original = pkgs.xorg.xorgserver;
    replacement = pkgs.xorg.xorgserver.overrideAttrs (old: {
      patches = old.patches ++ [
        (pkgs.fetchpatch
          {
            url = "https://github.com/komar007/xserver/compare/xorg-server-21.1.16...xorg-server-21.1.16_no_tear.patch";
            sha256 = "sha256-zihVEOHX7BjlMjPu9WwyAUBnd5JWViuJ2jrtwC6Dbfc=";
          })
      ];
    });
  }];

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

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

  time.timeZone = "Europe/Warsaw";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };
  console.keyMap = "pl2";

  networking = {
    hostName = "nixos";
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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    tig
    killall
    bc
    zip
    file

    man-pages

    pciutils
    usbutils
    nvme-cli

    openconnect
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  users.users.komar = {
    initialPassword = "test";
    isNormalUser = true;
    description = "Michał Trybus";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.komar =
    { config, ... }: (import ./home-manager/home.nix) {
      lib = pkgs.lib;
      inherit pkgs komar-nvim system;
    };

  services.openssh.enable = true;

  services.lighttpd = {
    enable = true;
    document-root = "/var/www";
  };

  services.kanata = {
    enable = true;
    keyboards."generic".config = builtins.readFile ./kanata-generic.kbd;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
