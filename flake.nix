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
      nixpkgs-stable = system: import inputs.nixpkgs {
        inherit system;
      };
      nixpkgs-unstable = system: import inputs.nixpkgs-unstable {
        inherit system;
      };
      komar-nvim = system: inputs.komar-nvim.packages.${system};

      nixosConfiguration = name: nixpkgs.lib.nixosSystem {
        specialArgs = {
          nixpkgs-unstable = nixpkgs-unstable system;
          komar-nvim = komar-nvim system;
        };
        modules = [
          ./machines/common.nix
          ./machines/${name}
        ];
      };

      homeConfiguration = name: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable system;
        extraSpecialArgs = {
          nixpkgs-unstable = nixpkgs-unstable system;
          komar-nvim = komar-nvim system;
        };
        modules = [
          ./homes/common.nix
          ./homes/${name}
        ];
      };
    in
    {
      nixosConfigurations = {
        home = nixosConfiguration "home";
      };
      homeConfigurations = {
        home = homeConfiguration "home";
      };
    };
}
