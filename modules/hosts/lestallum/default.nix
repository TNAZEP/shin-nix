{ inputs, config, ... }:
let
  userSettings = config.meta.settings;

  # Host-specific hardware configuration (no hyprland on this host)
  hostConfig = {
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refresh = 60;
        x = 0;
        y = 0;
        scale = 1.0;
        bitdepth = null;
        primary = true;
      }
    ];
    keyboard = config.meta.keyboard;
    cursor = config.meta.cursor;
    gtk = config.meta.gtk;
  };
in
{
  flake.nixosConfigurations.lestallum = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs hostConfig userSettings;
    };
    modules = [
      # Hardware
      ./_hardware-configuration.nix

      # Core
      inputs.self.nixosModules.nixosHost
      inputs.self.nixosModules.common

      # Desktop
      inputs.self.nixosModules.desktopGlue
      inputs.self.nixosModules.kdeCore
      inputs.self.nixosModules.kdeMultimedia

      # Apps & Utilities
      inputs.self.nixosModules.utilities
      inputs.self.nixosModules.editors
      inputs.self.nixosModules.terminal
      inputs.self.nixosModules.git
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.fonts
      inputs.self.nixosModules.qemu
      inputs.self.nixosModules.docker

      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs hostConfig userSettings;
        };
        home-manager.users.${userSettings.username} = {
          imports = [
            inputs.self.homeModules.common
            inputs.self.homeModules.terminal
            inputs.self.homeModules.editors
            inputs.self.homeModules.browsers
            inputs.self.homeModules.git
            inputs.self.homeModules.ssh
          ];
          home.username = userSettings.username;
          home.homeDirectory = "/home/${userSettings.username}";
          home.stateVersion = "25.11";
          programs.home-manager.enable = true;
        };
      }

      # Host-specific
      {
        networking.hostName = "lestallum";
        system.stateVersion = "25.11";
      }
    ];
  };
}
