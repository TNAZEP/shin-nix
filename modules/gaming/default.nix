{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud
        protontricks
        faugus-launcher

        (prismlauncher.override {
          jdks = [
            jdk8
            jdk17
            jdk21
            jdk
          ];
        })
        shipwright
      ];
    };

  flake.homeModules.gaming =
    { ... }:
    {
    };
}
