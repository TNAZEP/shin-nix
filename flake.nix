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

    antigravity-pkg.url = "github:nixos/nixpkgs/e9f0688b449dc77479548ae34e9ba8f6aa14e943";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      antigravity-pkg,
      ...
    }@inputs:
    let
      userSettings = {
        username = "tnazep";
        name = "TNAZEP";
        email = "jacob@ennaimi.com";
        dotfilesDir = "/home/tnazep/shin-nix";
        theme = "kanagawa-dragon";
        wm = "hyprland";
        browser = "firefox";
        term = "alacritty";
        font = "JetBrainsMono Nerd Font";
        editor = "nvim";
      };
    in
    {
      nixosConfigurations = {
        midgar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit userSettings;
            inherit antigravity-pkg;
          };
          modules = [
            disko.nixosModules.disko
            ./hosts/midgar/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
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
