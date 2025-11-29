{ inputs, config, ... }:
let
  userSettings = import ../../settings.nix;
in
{
  flake.nixosConfigurations.midgar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs userSettings;
    };
    modules = [
      inputs.disko.nixosModules.disko
      ./_disko.nix
      ./_hardware-configuration.nix

      inputs.self.nixosModules.common
      inputs.self.nixosModules.nvidia
      inputs.self.nixosModules.desktop
      inputs.self.nixosModules.gaming
      inputs.self.nixosModules.apps
      inputs.self.nixosModules.utilities

      inputs.home-manager.nixosModules.home-manager
      (
        { pkgs, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${userSettings.username} =
            { pkgs, ... }:
            {
              imports = [
                inputs.self.homeModules.common
                inputs.self.homeModules.nvidia
                inputs.self.homeModules.desktop
                inputs.self.homeModules.gaming
                inputs.self.homeModules.apps
                inputs.self.homeModules.utilities
              ];

              home.username = userSettings.username;
              home.homeDirectory = "/home/${userSettings.username}";
              home.stateVersion = "25.11";
              programs.home-manager.enable = true;

              programs.ssh = {
                enable = true;
                matchBlocks."*" = {
                  identityAgent = "~/.1password/agent.sock";
                };
              };

              programs.git = {
                enable = true;
                settings = {
                  user = {
                    name = userSettings.name;
                    email = userSettings.email;
                    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEclWROAzXXuA3fE8qIWW55pJLOewedBGS6bT6Sf3xG4";
                  };
                  "gpg \"ssh\"" = {
                    program = "${pkgs.lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
                  };
                  init.defaultBranch = "master";
                  commit.gpgSign = true;
                  gpg.format = "ssh";
                };
              };
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

          programs.ssh.startAgent = true;
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

          hardware.bluetooth.enable = true;
          hardware.bluetooth.powerOnBoot = true;
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
