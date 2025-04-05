{ lib, pkgs, ... }:
let
  pidtree_mon = pkgs.rustPlatform.buildRustPackage rec {
    pname = "pidtree_mon";
    version = "0.2.2";
    src = pkgs.fetchCrate {
      inherit pname version;
      hash = "sha256-METVcuLDXXRjoYSuPGHj0Kv1QzpwIdnIBoCeQi5a38w=";
    };
    cargoHash = "sha256-6Z5dBwidZBz5Urt/n33l1MZRO4txDcG1Qk8RQmg6UoI=";
  };
in
{
  home.packages = with pkgs; [
    # dependencies of tmux config
    # TODO: define them all, manage config using home-manager,
    # don't expose all dependencies to the system
    fzf
    bat
    xsel
    pidtree_mon

    tmux
  ];
}
