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
      services.resolved = {
        enable = true;
        dnsovertls = "true";
        dnssec = "true";
        fallbackDns = [
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
          "8.8.8.8#dns.google"
        ];
      };
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

  # Darwin equivalent build script
  flake.darwinModules.darwinHost =
    { pkgs, ... }:
    {
      # User shell configuration
      programs.zsh.enable = true;

      environment.systemPackages = [
        (pkgs.writeShellScriptBin "zepbuild" ''
          YELLOW='\033[1;33m'
          GREEN='\033[0;32m'
          RED='\033[0;31m'
          NC='\033[0m'

          # Get hostname dynamically
          HOSTNAME=$(scutil --get LocalHostName)

          echo -e "''${YELLOW}Building $HOSTNAME...''${NC}"
          cd ${userSettings.dotfilesDir}
          if darwin-rebuild switch --flake ".#$HOSTNAME" "$@"; then
            echo -e "''${GREEN}✓ Build Successful!''${NC}"

            echo -e "''${YELLOW}Running Garbage Collection...''${NC}"
            nix-collect-garbage -d --delete-older-than 30d

            echo -e "''${GREEN}✓ Done.''${NC}"
          else
            echo -e "''${RED}✗ Build Failed. Skipping Garbage Collection.''${NC}"
            exit 1
          fi
        '')
      ];
    };
}

