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
      #inputs.self.darwinModules.yabai
      inputs.self.darwinModules.utilities
      inputs.self.darwinModules.vpn
      inputs.self.darwinModules.browsers
      inputs.self.darwinModules.communication
      inputs.self.darwinModules.editors
      inputs.self.darwinModules.fonts
      inputs.self.darwinModules.git
      inputs.self.darwinModules.terminal
      inputs.nix-homebrew.darwinModules.nix-homebrew
      (
        { ... }:
        {
          # Nix configuration
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          # System configuration
          system.stateVersion = 5;
          system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
          system.primaryUser = "tnazep";

          system.defaults.dock = {
            autohide = true;
            autohide-delay = 0.05;
            autohide-time-modifier = 0.0;
            show-recents = false;
          };

          system.defaults.trackpad = {
            Clicking = true;

          };

          system.defaults.CustomUserPreferences = {
            NSGlobalDomain = {
              # Add a context menu item for showing the Web Inspector in web views
              WebKitDeveloperExtras = true;
            };
            "com.apple.finder" = {
              ShowExternalHardDrivesOnDesktop = true;
              ShowHardDrivesOnDesktop = false;
              ShowMountedServersOnDesktop = false;
              ShowRemovableMediaOnDesktop = false;
              _FXSortFoldersFirst = true;
              # When performing a search, search the current folder by default
              FXDefaultSearchScope = "SCcf";
            };
            "com.apple.desktopservices" = {
              # Avoid creating .DS_Store files on network or USB volumes
              DSDontWriteNetworkStores = true;
              DSDontWriteUSBStores = true;
            };
            "com.apple.screensaver" = {
              # Require password immediately after sleep or screen saver begins
              askForPassword = 1;
              askForPasswordDelay = 0;
            };
            "com.apple.screencapture" = {
              location = "~/Desktop";
              type = "png";
            };
            "com.apple.mail" = {
              # Disable inline attachments (just show the icons)
              DisableInlineAttachmentViewing = true;
            };
            "com.apple.AdLib" = {
              allowApplePersonalizedAdvertising = false;
            };
            "com.apple.print.PrintingPrefs" = {
              # Automatically quit printer app once the print jobs complete
              "Quit When Finished" = true;
            };
            "com.apple.SoftwareUpdate" = {
              AutomaticCheckEnabled = true;
              # Check for software updates daily, not just once per week
              ScheduleFrequency = 1;
              # Download newly available updates in background
              AutomaticDownload = 1;
              # Install System data files & security updates
              CriticalUpdateInstall = 1;
            };
            "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
            # Prevent Photos from opening automatically when devices are plugged in
            "com.apple.ImageCapture".disableHotPlug = true;
            # Turn on app auto-update
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

          # Programs
          programs.zsh.enable = true;

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
        }
      )
    ];
  };
}
