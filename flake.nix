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
    in
    {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          specialArgs = with inputs; {
            inherit nixpkgs-unstable;
            inherit komar-nvim;
            inherit system;
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
          extraSpecialArgs = with inputs; {
            inherit system;
            inherit komar-nvim;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
