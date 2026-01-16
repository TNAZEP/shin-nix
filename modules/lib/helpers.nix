# Helper functions for reducing boilerplate across NixOS, Darwin, and Home Manager modules
{ lib, ... }:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = rec {
    # Create a module that works on both NixOS and Darwin with shared system packages
    mkSystemModule =
      {
        name,
        systemPackages ? [ ],
        nixosConfig ? { },
        darwinConfig ? { },
        sharedConfig ? { },
      }:
      {
        flake.nixosModules.${name} =
          { pkgs, ... }:
          lib.recursiveUpdate (
            lib.recursiveUpdate sharedConfig {
              environment.systemPackages = map (p: if builtins.isFunction p then p pkgs else p) systemPackages;
            }
          ) (if builtins.isFunction nixosConfig then nixosConfig pkgs else nixosConfig);

        flake.darwinModules.${name} =
          { pkgs, ... }:
          let
            filterAvailable = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform);
            resolvedPackages = map (p: if builtins.isFunction p then p pkgs else p) systemPackages;
          in
          lib.recursiveUpdate (
            lib.recursiveUpdate sharedConfig {
              environment.systemPackages = filterAvailable resolvedPackages;
            }
          ) (if builtins.isFunction darwinConfig then darwinConfig pkgs else darwinConfig);
      };

    # Create home module with optional platform-specific config
    mkHomeModule =
      {
        name,
        packages ? [ ],
        config,
        darwinExtra ? { },
        linuxExtra ? { },
      }:
      {
        flake.homeModules.${name} =
          { pkgs, ... }:
          let
            filterAvailable = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform);
            resolvedPackages = map (p: if builtins.isFunction p then p pkgs else p) packages;
            platformConfig =
              if pkgs.stdenv.isDarwin then
                darwinExtra
              else
                linuxExtra;
          in
          lib.recursiveUpdate (
            lib.recursiveUpdate (if builtins.isFunction config then config pkgs else config) {
              home.packages = filterAvailable resolvedPackages;
            }
          ) (if builtins.isFunction platformConfig then platformConfig pkgs else platformConfig);
      };

    # Helper to make a module with an enable option
    mkOptionalModule =
      {
        name,
        description,
        moduleConfig,
      }:
      { config, lib, ... }:
      {
        options.modules.${name}.enable = lib.mkEnableOption description;
        config = lib.mkIf config.modules.${name}.enable moduleConfig;
      };
  };
}
