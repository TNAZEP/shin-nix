# Gaming module aggregator with enable options
{ inputs, ... }:
{
  flake.nixosModules.gaming =
    { config, lib, pkgs, ... }:
    let
      cfg = config.modules.gaming;
    in
    {
      options.modules.gaming = {
        enable = lib.mkEnableOption "gaming support";

        steam = {
          enable = lib.mkEnableOption "Steam and Proton gaming";
          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Additional gaming packages to install";
          };
        };

        minecraft.enable = lib.mkEnableOption "Minecraft with Prism Launcher";
        retro.enable = lib.mkEnableOption "retro gaming (recomps, sourceports)";
      };

      config = lib.mkIf cfg.enable {
        # Steam configuration
        programs.steam = lib.mkIf cfg.steam.enable {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          gamescopeSession.enable = true;
        };

        programs.gamemode.enable = cfg.steam.enable;

        environment.systemPackages = lib.flatten [
          # Steam packages
          (lib.optionals cfg.steam.enable (with pkgs; [
            mangohud
            protontricks
            protonup-qt
            protonplus
            faugus-launcher
            lsfg-vk
            lsfg-vk-ui
            heroic
          ] ++ cfg.steam.extraPackages))

          # Minecraft related packages
          (lib.optionals cfg.minecraft.enable [
            (pkgs.prismlauncher.override {
              jdks = with pkgs; [ jdk8 jdk17 jdk21 jdk ];
            })
            inputs.hytale-launcher.packages.${pkgs.system}.default
          ])

          # Retro gaming packages
          (lib.optionals cfg.retro.enable (with pkgs; [
            shipwright
            _2ship2harkinian
            perfect_dark
            ironwail
          ]))
        ];
      };
    };
}
