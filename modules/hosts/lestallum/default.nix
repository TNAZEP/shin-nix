{
  pkgs,
  inputs,
  config,
  ...
}:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosConfigurations.lestallum = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware-configuration.nix

      inputs.self.nixosModules.common
      inputs.self.nixosModules.desktopGlue
      inputs.self.nixosModules.plasma
      inputs.self.nixosModules.apps
      inputs.self.nixosModules.utilities
      inputs.self.nixosModules.editors
      inputs.self.nixosModules.terminal
      inputs.self.nixosModules.git
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.fonts
      inputs.self.nixosModules.qemu
      inputs.self.nixosModules.docker

      inputs.home-manager.nixosModules.home-manager
      (
        { ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${userSettings.username} =
            { pkgs, ... }:
            {
              imports = [
                inputs.self.homeModules.common
                inputs.self.homeModules.desktopGlue
                inputs.self.homeModules.apps
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
          services.flatpak.enable = true;
          services.gvfs.enable = true;
          services.tumbler.enable = true;

          programs.zsh.enable = true;
          programs.fuse.userAllowOther = true;
          system.stateVersion = "25.11";

          environment.systemPackages = with pkgs; [
            (writeShellScriptBin "zepbuild" ''
              echo -e "''${YELLOW}Building lestallum...''${NC}"
              cd shin-nix
              if nixos-rebuild switch --flake .#lestallum --log-format internal-json -v "$@" |& ${pkgs.nix-output-monitor}/bin/nom --json; then
                echo -e "''${GREEN} Build Successful!''${NC}"

                echo -e "''${YELLOW} Running Garbage Collection...''${NC}"
                nix-env -p /nix/var/nix/profiles/system --delete-generations +10

                nix-collect-garbage

                echo -e "''${GREEN} Done. Kept last 10 generations.''${NC}"
              else
                echo -e "''${RED} Build Failed. Skipping Garbage Collection.''${NC}"
                exit 1
              fi
            '')
          ];
        }
      )
    ];
  };
}
