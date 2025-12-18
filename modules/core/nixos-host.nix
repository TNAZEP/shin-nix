# Shared NixOS configuration for all hosts
{ config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosModules.nixosHost =
    { pkgs, ... }:
    {
      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Networking
      networking.networkmanager.enable = true;

      # User configuration
      users.users.${userSettings.username} = {
        isNormalUser = true;
        description = userSettings.name;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
      };

      # Common services
      services.fwupd.enable = true;
      services.fstrim.enable = true;
      services.resolved.enable = true;
      services.flatpak.enable = true;
      services.gvfs.enable = true;
      services.tumbler.enable = true;

      # Shell
      programs.zsh.enable = true;
      programs.fuse.userAllowOther = true;

      # Build script - generates a zepbuild command for the current host
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "zepbuild" ''
          YELLOW='\033[1;33m'
          GREEN='\033[0;32m'
          RED='\033[0;31m'
          NC='\033[0m'

          # Get hostname dynamically
          HOSTNAME=$(hostname)

          echo -e "''${YELLOW}Building $HOSTNAME...''${NC}"
          cd ${userSettings.dotfilesDir}
          if nixos-rebuild switch --flake ".#$HOSTNAME" --log-format internal-json -v "$@" |& ${pkgs.nix-output-monitor}/bin/nom --json; then
            echo -e "''${GREEN}✓ Build Successful!''${NC}"

            echo -e "''${YELLOW}Running Garbage Collection...''${NC}"
            nix-env -p /nix/var/nix/profiles/system --delete-generations +10

            nix-collect-garbage

            echo -e "''${GREEN}✓ Done. Kept last 10 generations.''${NC}"
          else
            echo -e "''${RED}✗ Build Failed. Skipping Garbage Collection.''${NC}"
            exit 1
          fi
        '')
      ];
    };
}

