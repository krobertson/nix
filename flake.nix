{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs =
    { nixpkgs, home-manager, nixos-hardware, lazyvim, nix-flatpak, ... }:
    {
      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
          ./wayland.nix
          nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ken = import ./home.nix;
              backupFileExtension = "backup";
              sharedModules = [
                lazyvim.homeManagerModules.lazyvim
              ];
            };
          }
        ];
      };
    };
}
