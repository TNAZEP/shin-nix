{
  flake.nixosModules.kdeCore =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;

      environment.systemPackages = with pkgs.kdePackages; [
        # Core/System
        dolphin
        ark
        filelight
        kcharselect
        kdebugsettings
        kdialog
        kfind
        kgpg
        kio-extras
        ksystemlog
        kwallet-pam
        kwalletmanager
        partitionmanager
        plasma-systemmonitor
        polkit-kde-agent-1
        print-manager
        systemsettings

        # Internet/Network
        akonadi
        kget
        kio-gdrive
        plasma-browser-integration
        plasma-nm

        # Theming/Customization
        breeze
        breeze-gtk
        breeze-icons
        kde-gtk-config
        oxygen

        # Libraries/Frameworks
        knewstuff
        kirigami
        kirigami-addons
        ksvg
        kdeclarative
        kcmutils
        qqc2-desktop-style
        kitemmodels
      ];
    };
}

