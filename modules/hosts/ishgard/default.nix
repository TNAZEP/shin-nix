{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.darwinConfigurations.ishgard = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.darwinModules.common
      inputs.self.darwinModules.utilities
      inputs.self.darwinModules.vpn
      inputs.self.darwinModules.browsers
      inputs.self.darwinModules.communication
      inputs.self.darwinModules.editors
      inputs.self.darwinModules.fonts
      inputs.self.darwinModules.git
      inputs.self.darwinModules.terminal
      inputs.nix-homebrew.darwinModules.nix-homebrew

      ({ ... }: {
        # System configuration
        system.stateVersion = 5;
        system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
        system.primaryUser = userSettings.username;

        # macOS defaults
        system.defaults.dock = {
          autohide = true;
          autohide-delay = 0.05;
          autohide-time-modifier = 0.0;
          show-recents = false;
        };

        system.defaults.trackpad.Clicking = true;

        system.defaults.CustomUserPreferences = {
          NSGlobalDomain.WebKitDeveloperExtras = true;
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = false;
            ShowMountedServersOnDesktop = false;
            ShowRemovableMediaOnDesktop = false;
            _FXSortFoldersFirst = true;
            FXDefaultSearchScope = "SCcf";
          };
          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.screensaver" = {
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.screencapture" = {
            location = "~/Desktop";
            type = "png";
          };
          "com.apple.mail".DisableInlineAttachmentViewing = true;
          "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
          "com.apple.print.PrintingPrefs"."Quit When Finished" = true;
          "com.apple.SoftwareUpdate" = {
            AutomaticCheckEnabled = true;
            ScheduleFrequency = 1;
            AutomaticDownload = 1;
            CriticalUpdateInstall = 1;
          };
          "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
          "com.apple.ImageCapture".disableHotPlug = true;
          "com.apple.commerce".AutoUpdate = true;
        };

        # Users
        users.users.${userSettings.username} = {
          name = userSettings.username;
          home = "/Users/${userSettings.username}";
        };

        # Networking
        networking.hostName = "ishgard";

        # Homebrew
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          user = userSettings.username;
          autoMigrate = true;
        };

        homebrew = {
          enable = true;
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        # Home Manager
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${userSettings.username} = {
          imports = [
            inputs.self.homeModules.common
            inputs.self.homeModules.terminal
            inputs.self.homeModules.editors
            inputs.self.homeModules.browsers
            inputs.self.homeModules.git
            inputs.self.homeModules.ssh
          ];
          home.stateVersion = "25.11";
        };
      })
    ];
  };
}
