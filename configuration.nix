{ config
, pkgs
, ...
}: {
  nixpkgs.overlays = [
    (final: prev:
      {
        xorg = prev.xorg // {
          xorgserver = prev.xorg.xorgserver.overrideAttrs (old: {
            patches = old.patches ++ [
              (final.fetchpatch
                {
                  url = "https://github.com/komar007/xserver/compare/xorg-server-21.1.13...xorg-server-21.1.13_test_no_tear.patch";
                  sha256 = "sha256-xMyMMc8St6br+Lq8jS1SD8vOKONhoPJ8IwPU0Y6ct1M=";
                })
            ];
          });
        };
      }
    )
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-sdk
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  services.printing.enable = true;

  sound.enable = true;
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

    pciutils

    openconnect
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  users.users.komar = {
    isNormalUser = true;
    description = "Michał Trybus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      pstree # required by PS1
      jq # required by PS1
      fzf
      tmux

      xmonad-with-packages
      pulsemixer
      alacritty
      xsel
      dzen2
      xmobar
      htop

      firefox
      google-chrome

      gnumake
      cmake
      gcc
      rustup

      mpv
      super-slicer-latest

      imagemagick
    ];
  };

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
