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
      inputs.self.darwinModules.apps
      inputs.self.darwinModules.vpn
      inputs.self.darwinModules.browsers
      inputs.self.darwinModules.communication
      inputs.self.darwinModules.editors
      inputs.self.darwinModules.fonts
      inputs.self.darwinModules.git
      inputs.self.darwinModules.ssh
      inputs.self.darwinModules.terminal
      inputs.nix-homebrew.darwinModules.nix-homebrew
      (
        { pkgs, ... }:
        {
          # Nix configuration
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          # System configuration
          system.stateVersion = 5;
          system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

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
              inputs.self.homeModules.apps
              inputs.self.homeModules.communication
              inputs.self.homeModules.utilities
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
