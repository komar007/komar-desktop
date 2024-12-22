{
  description = "komar NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
