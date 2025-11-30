{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosConfigurations.lestallum = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      ./_disko.nix
      ./_hardware-configuration.nix

      inputs.self.nixosModules.common
      inputs.self.nixosModules.utilities
      inputs.self.nixosModules.git
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.terminal
      inputs.self.nixosModules.vpn

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
                inputs.self.homeModules.utilities
                inputs.self.homeModules.terminal
                inputs.self.homeModules.git
                inputs.self.homeModules.ssh
              ];

              home.username = userSettings.username;
              home.homeDirectory = "/home/${userSettings.username}";
              home.stateVersion = "25.11";
              programs.home-manager.enable = true;

            };
        }
      )
      (
        { pkgs, ... }:
        {
          networking.hostName = "lestallum";
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

          programs.zsh.enable = true;
          system.stateVersion = "25.11";
        }
      )
    ];
  };
}
