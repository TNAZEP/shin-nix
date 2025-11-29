{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # We'll rely on the config file for now, but we can move settings here later
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };

  # Source other config files
  xdg.configFile."hypr/hyprland".source = ./config/hypr/hyprland;
  xdg.configFile."hypr/custom".source = ./config/hypr/custom;

  # Waybar
  programs.waybar = {
    enable = true;
    style = ./config/waybar/style.css;
  };
  xdg.configFile."waybar/config".source = ./config/waybar/config;

  # Rofi
  home.packages = [
    pkgs.rofi
    pkgs.swww
    pkgs.kdePackages.polkit-kde-agent-1
  ];
  xdg.configFile."rofi/config.rasi".source = ./config/rofi/config.rasi;

  # Dunst
  services.dunst = {
    enable = true;
    configFile = ./config/dunst/dunstrc;
  };
}
