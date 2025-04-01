{ config, pkgs, nixpkgs-unstable, komar-nvim, ...}: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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

  environment.systemPackages = with pkgs; [
    home-manager

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

  services.kanata = {
    enable = true;
    keyboards."generic".config = builtins.readFile ../kanata-generic.kbd;
  };
}
