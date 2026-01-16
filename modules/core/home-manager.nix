# Shared Home Manager configuration helper
{ config, inputs, lib, ... }:
let
  userSettings = config.meta.settings;
in
{
  # Shared home-manager configuration for NixOS hosts
  config.flake.nixosModules.homeManagerNixOS =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
      };
    };

  # Helper function to create user home config with common settings
  options.flake.mkHomeConfig = lib.mkOption {
    type = lib.types.functionTo lib.types.unspecified;
    default = { extraModules ? [ ], stateVersion ? "25.11" }: {
      home-manager.users.${userSettings.username} = {
        imports = [
          inputs.self.homeModules.common
          inputs.self.homeModules.terminal
          inputs.self.homeModules.editors
          inputs.self.homeModules.browsers
          inputs.self.homeModules.git
          inputs.self.homeModules.ssh
        ] ++ extraModules;

        home.username = userSettings.username;
        home.homeDirectory =
          if builtins.match ".*darwin.*" builtins.currentSystem != null
          then "/Users/${userSettings.username}"
          else "/home/${userSettings.username}";
        home.stateVersion = stateVersion;
        programs.home-manager.enable = true;
      };
    };
    description = "Helper to generate home-manager user config";
  };
}
