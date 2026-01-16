{ config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosModules.desktopGlue =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      services.displayManager.sddm.enable = true;

      services.xserver.xkb = {
        layout = userSettings.keyboardLayout;
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
        qt6Packages.qt6ct
        libsForQt5.qt5ct
        qt6Packages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
        yaru-theme
        papirus-icon-theme
        adwaita-icon-theme
        pavucontrol
      ];

      environment.variables.QT_QPA_PLATFORMTHEME = "kde";

      programs.dconf.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-hyprland
          pkgs.kdePackages.xdg-desktop-portal-kde
          pkgs.xdg-desktop-portal-gnome
        ];
        config = {
          common = {
            default = [ "gtk" ];
          };
          hyprland = {
            default = [ "hyprland" "kde" "gtk" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
            "org.freedesktop.impl.portal.AppChooser" = [ "kde" ];
            "org.freedesktop.impl.portal.Settings" = [ "kde" ];
            "org.freedesktop.impl.portal.OpenURI" = [ "gnome" ];
          };
        };
      };

      # Enable KDE portal systemd user service
      systemd.user.services.xdg-desktop-portal-kde = {
        description = "Portal service (KDE implementation)";
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "dbus";
          BusName = "org.freedesktop.impl.portal.desktop.kde";
          ExecStart = "${pkgs.kdePackages.xdg-desktop-portal-kde}/libexec/xdg-desktop-portal-kde";
          Restart = "on-failure";
        };
      };
    };

}
