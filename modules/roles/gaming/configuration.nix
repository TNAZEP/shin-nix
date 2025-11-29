{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protontricks
    faugus-launcher
    vesktop
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
}
