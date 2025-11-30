{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosConfigurations.midgar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      ./_disko.nix
      ./_hardware-configuration.nix

      inputs.self.nixosModules.common
      inputs.self.nixosModules.nvidia
      inputs.self.nixosModules.bluetooth
      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.plasma
      inputs.self.nixosModules.hyprland
      inputs.self.nixosModules.gaming
      inputs.self.nixosModules.apps
      inputs.self.nixosModules.communication
      inputs.self.nixosModules.utilities
      inputs.self.nixosModules.editors
      inputs.self.nixosModules.terminal
      inputs.self.nixosModules.git
      inputs.self.nixosModules.ssh

      inputs.home-manager.nixosModules.home-manager
      (
        { pkgs, ... }:
        {
          _module.args = {
            inherit userSettings inputs;
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${userSettings.username} =
            { pkgs, ... }:
            {
              imports = [
                inputs.self.homeModules.common
                inputs.self.homeModules.nvidia
                inputs.self.homeModules.bluetooth
                inputs.self.homeModules.desktop
                inputs.self.homeModules.hyprland
                inputs.self.homeModules.gaming
                inputs.self.homeModules.apps
                inputs.self.homeModules.communication
                inputs.self.homeModules.utilities
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
          home-manager.extraSpecialArgs = {
            inherit userSettings inputs;
          };
        }
      )
      (
        { pkgs, ... }:
        {
          networking.hostName = "midgar";
          networking.networkmanager.enable = true;
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          users.users.${userSettings.username} = {
            isNormalUser = true;
            description = userSettings.name;
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
            shell = pkgs.zsh;
          };

          services.fwupd.enable = true;
          services.fstrim.enable = true;
          services.resolved.enable = true;
          services.flatpak.enable = true;
          services.gvfs.enable = true;
          services.tumbler.enable = true;
          services.tailscale.enable = true;
          services.mullvad-vpn = {
            enable = true;
            package = pkgs.mullvad-vpn;
          };

          programs.zsh.enable = true;
          programs.fuse.userAllowOther = true;
          system.stateVersion = "25.11";

          fonts.packages = with pkgs.nerd-fonts; [
            fira-code
            jetbrains-mono
            bigblue-terminal
          ];
        }
      )
    ];
  };
}
