{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosConfigurations.midgar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # Hardware & Disk
      inputs.disko.nixosModules.disko
      ./_disko.nix
      ./_hardware-configuration.nix

      # Shared NixOS configuration
      inputs.self.nixosModules.nixosHost
      inputs.self.nixosModules.common

      # Hardware-specific
      inputs.self.nixosModules.amd
      inputs.self.nixosModules.bluetooth

      # Desktop
      inputs.self.nixosModules.desktopGlue
      inputs.self.nixosModules.kdeCore
      inputs.self.nixosModules.kdeMultimedia
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

      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
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

      # Host-specific configuration
      ({ pkgs, ... }: {
        networking.hostName = "midgar";
        system.stateVersion = "25.11";
        boot.kernelPackages = pkgs.linuxPackages_latest;
      })
    ];
  };
}
