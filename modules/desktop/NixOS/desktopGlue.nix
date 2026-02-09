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
        xdg-utils
        # GTK/GNOME theming
        adwaita-icon-theme
        adw-gtk3
        yaru-theme
        papirus-icon-theme
        pavucontrol
        # QT styling for GNOME
        qgnomeplatform
        qgnomeplatform-qt6
        adwaita-qt
        adwaita-qt6
        # dconf/gsettings schemas
        gsettings-desktop-schemas
        gnome-settings-daemon
        dconf
      ];

      # Use GNOME/Adwaita for QT apps
      environment.variables = {
        QT_QPA_PLATFORMTHEME = "gnome";
        QT_STYLE_OVERRIDE = "adwaita-dark";
      };

      # Ensure gsettings schemas are found and libadwaita reads from dconf
      environment.sessionVariables = {
        XDG_DATA_DIRS = [ "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" ];
        # Force libadwaita to read from GSettings/dconf instead of portal
        ADW_DISABLE_PORTAL = "1";
        GSETTINGS_BACKEND = "dconf";
      };

      programs.dconf.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-hyprland
        ];
        config = {
          common.default = [ "gtk" ];
          hyprland = {
            default = [ "hyprland" "gtk" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
            "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
            "org.freedesktop.impl.portal.Screencast" = [ "hyprland" ];
          };
        };
      };
    };
}
