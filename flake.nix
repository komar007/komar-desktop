{
  description = "komar NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    komar-nvim.url = "github:komar007/neovim-config";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      nixpkgs-unstable = system: import inputs.nixpkgs-unstable {
        inherit system;
      };
      komar-nvim = system: inputs.komar-nvim.packages.${system};
    in
    {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          specialArgs = {
            nixpkgs-unstable = nixpkgs-unstable system;
            komar-nvim = komar-nvim system;
          };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
      homeConfigurations = {
        komar = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            komar-nvim = komar-nvim system;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
