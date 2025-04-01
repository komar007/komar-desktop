{ config, pkgs, nixpkgs-unstable, komar-nvim, ...}: {
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
}
