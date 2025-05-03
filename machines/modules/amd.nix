{ config, pkgs, nixpkgs-unstable, ...}: {
  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];
}
