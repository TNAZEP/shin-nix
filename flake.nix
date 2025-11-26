{
  description = "Shin-NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      ...
    }@inputs:
    let
      userSettings = import ./settings.nix;
    in
    {
      nixosConfigurations = {
        midgar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit userSettings;
          };
          modules = [
            disko.nixosModules.disko
            ./hosts/midgar/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${userSettings.username} = import ./hosts/midgar/home.nix;
              home-manager.extraSpecialArgs = {
                inherit userSettings;
                inherit inputs;
              };
            }
            {
              environment.systemPackages = [
              ];
            }
          ];
        };
      };
    };
}
