{ ... }:
{
  flake.nixosModules.desktopGlue =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      services.displayManager.sddm.enable = true;

      services.xserver.xkb = {
        layout = "se";
        variant = "";
      };

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      environment.systemPackages = with pkgs; [
        qt6Packages.qt6ct
        libsForQt5.qt5ct
        qt6Packages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
        yaru-theme
        papirus-icon-theme
        adwaita-icon-theme
        pavucontrol
      ];

      environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";

      programs.dconf.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-hyprland
        ];
        config = {
          common = {
            default = [ "gtk" ];
          };
          hyprland = {
            default = [ "hyprland" "gtk" ];
          };
        };
      };
    };

  flake.homeModules.desktopGlue =
    {
      ...
    }:
    {
    };
}
