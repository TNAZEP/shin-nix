{
  flake.nixosModules.plasma =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;
      environment.systemPackages = with pkgs.kdePackages; [
        # Core/System
        dolphin
        konsole
        kate
        kcalc
        spectacle
        ark
        filelight
        kcharselect
        kdebugsettings
        kdialog
        kfind
        kgpg
        khelpcenter
        kio-extras
        ksystemlog
        kwallet-pam
        kwalletmanager
        partitionmanager
        plasma-systemmonitor
        polkit-kde-agent-1
        print-manager
        systemsettings
        xdg-desktop-portal-kde

        # Internet/Network
        kmail
        kontact
        korganizer
        kaddressbook
        akonadi
        kget
        kio-gdrive

        ktorrent
        plasma-browser-integration
        plasma-nm

        # Multimedia
        elisa
        kdenlive
        dragon
        ffmpegthumbs
        gwenview
        k3b
        kamoso
        kimageformats
        audiocd-kio

        # Office/Productivity
        okular
        falkon

        # Utilities/Accessories
        kalarm

        ktimer
        kweather

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

  flake.homeModules.plasma =
    { ... }:
    {
    };
}
