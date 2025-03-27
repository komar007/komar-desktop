{
  description = "komar NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit nixpkgs-unstable; inherit system; };
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
