{
  flake.nixosModules.gnome =
    { pkgs, ... }:
    {
      # GNOME desktop (display manager handled by desktopGlue's SDDM)
      services.desktopManager.gnome.enable = true;

      # Exclude some default GNOME packages
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-connections
        epiphany # Web browser
        geary # Email client
        yelp # Help viewer
      ];

      environment.systemPackages = with pkgs; [
        # Core GNOME apps
        gnome-tweaks
        gnome-terminal
        gnome-system-monitor
        gnome-disk-utility
        nautilus
        file-roller

        # Utilities
        gnome-calculator
        gnome-calendar
        gnome-clocks
        gnome-weather
        gnome-maps
        gnome-photos
        loupe # Image viewer

        # Media
        totem # Video player
        gnome-music

        # GNOME Shell extensions
        gnomeExtensions.appindicator
        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
        gnomeExtensions.caffeine

        # Theming
        adw-gtk3
        papirus-icon-theme
        nwg-look # GTK settings editor for wlroots compositors
      ];

      # Enable GNOME services
      services.gnome.gnome-keyring.enable = true;
      services.gnome.gcr-ssh-agent.enable = false; # Use existing SSH agent instead
      programs.dconf.enable = true;

      # For AppIndicator extension
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
    };
}
