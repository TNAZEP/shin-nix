{
  flake.nixosModules.hyprland =
    { ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };

  flake.homeModules.hyprland =
    { config, pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;

        # Temporarily using config file, will migrate to declarative config later
        extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
      };

      xdg.configFile."hypr/hyprland".source = ./config/hypr/hyprland;
      xdg.configFile."hypr/custom".source = ./config/hypr/custom;

      programs.waybar = {
        enable = true;
        style = ./config/waybar/style.css;
      };
      xdg.configFile."waybar/config".source = ./config/waybar/config;

      home.packages = [
        pkgs.rofi
        pkgs.swww
        pkgs.kdePackages.polkit-kde-agent-1
      ];
      xdg.configFile."rofi/config.rasi".source = ./config/rofi/config.rasi;

      services.dunst = {
        enable = true;
        configFile = ./config/dunst/dunstrc;
      };
    };
}
