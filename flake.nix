{
  description = "komar NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # the last commit of nixpkgs-24.11 with linux-6.6.91 where wake up from hibernate does not go to blank screen on framework laptop 13...
    nixpkgs-kernel-good-hibernate.url = "github:nixos/nixpkgs/d026ae960ca4b24ca265223cbc9d3222d936e90d";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot-nvim = {
      url = "github:komar007/dot-nvim";
      inputs.flake-utils.follows = "flake-utils";
    };
    dot-tmux = {
      url = "github:komar007/dot-tmux";
      inputs.flake-utils.follows = "flake-utils";
    };
    grub-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      nixpkgs-stable = system: import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.nur.overlays.default
          inputs.nixgl.overlay
        ];
      };
      nixpkgs-unstable = system: import inputs.nixpkgs-unstable {
        inherit system;
      };
      nixpkgs-kernel-good-hibernate = system: import inputs.nixpkgs-kernel-good-hibernate {
        inherit system;
      };
      nvim-module = system: inputs.dot-nvim.homeManagerModules.${system}.default;
      tmux-module = system: inputs.dot-tmux.homeManagerModules.${system}.default;
      tmux-alacritty-module = system: inputs.dot-tmux.homeManagerModules.${system}.alacrittyKeyBinds;
      grub-themes-module = system: inputs.grub-themes.nixosModules.default;

      nixosConfiguration = name: system: nixpkgs.lib.nixosSystem {
        specialArgs = {
          nixos-hardware = inputs.nixos-hardware;
          nixpkgs-unstable = nixpkgs-unstable system;
          nixpkgs-kernel-good-hibernate = nixpkgs-kernel-good-hibernate system;
          grub-themes-module = grub-themes-module system;
        };
        modules = [
          ./machines/common.nix
          ./machines/${name}
        ];
      };

      homeConfiguration = name: system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable system;
        extraSpecialArgs = {
          nixpkgs-unstable = nixpkgs-unstable system;
          nvim-module = nvim-module system;
          tmux-module = tmux-module system;
          tmux-alacritty-module = tmux-alacritty-module system;
          nixgl = inputs.nixgl;
        };
        modules = [
          ./homes/common.nix
          ./homes/${name}
        ];
      };
    in
    {
      nixosConfigurations = {
        thinkcentre = nixosConfiguration "thinkcentre" "x86_64-linux";
        framework = nixosConfiguration "framework" "x86_64-linux";
      };
      homeConfigurations = {
        thinkcentre = homeConfiguration "thinkcentre" "x86_64-linux";
        framework = homeConfiguration "framework" "x86_64-linux";
        work = homeConfiguration "work" "x86_64-linux";
      };
    };
}
