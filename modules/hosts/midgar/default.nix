{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
  colors = config.meta.theme.colors;

  # Host-specific hardware configuration
  hostConfig = {
    monitors = [
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        refresh = 240;
        x = 1920;
        y = 0;
        scale = 1.0;
        bitdepth = 10;
        primary = true;
      }
      {
        name = "DP-2";
        width = 1920;
        height = 1080;
        refresh = 144;
        x = 0;
        y = 360;
        scale = 1.0;
        bitdepth = null;
        primary = false;
      }
    ];
    keyboard = config.meta.keyboard;
    cursor = config.meta.cursor;
    gtk = config.meta.gtk;
  };
in
{
  flake.nixosConfigurations.midgar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs hostConfig colors userSettings;
    };
    modules = [
      # Hardware & Disk
      inputs.disko.nixosModules.disko
      ./_disko.nix
      ./_hardware-configuration.nix

      # Core
      inputs.self.nixosModules.nixosHost
      inputs.self.nixosModules.common

      # Hardware-specific
      inputs.self.nixosModules.amd
      inputs.self.nixosModules.bluetooth

      # Desktop
      inputs.self.nixosModules.desktopGlue
      inputs.self.nixosModules.gnome
      inputs.self.nixosModules.hyprland

      # Gaming
      inputs.self.nixosModules.steam
      inputs.self.nixosModules.minecraft
      inputs.self.nixosModules.retro

      # Apps & Utilities
      inputs.self.nixosModules.communication
      inputs.self.nixosModules.utilities
      inputs.self.nixosModules.editors
      inputs.self.nixosModules.terminal
      inputs.self.nixosModules.git
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.fonts
      inputs.self.nixosModules.vpn
      inputs.self.nixosModules.qemu
      inputs.self.nixosModules.docker
      inputs.self.nixosModules.waydroid
      inputs.self.nixosModules.java
      inputs.self.nixosModules.mediaEditors

      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs hostConfig colors userSettings;
        };
        home-manager.users.${userSettings.username} = {
          imports = [
            inputs.self.homeModules.common
            inputs.self.homeModules.hyprland
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
      ({ pkgs, ... }: {
        networking.hostName = "midgar";
        system.stateVersion = "25.11";
        boot.kernelPackages = pkgs.linuxPackages_latest;
      })
    ];
  };
}
