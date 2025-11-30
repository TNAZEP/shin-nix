{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.darwinConfigurations.ishgard = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      inputs.self.darwinModules.common
      inputs.self.darwinModules.utilities
      inputs.self.darwinModules.apps
      inputs.self.darwinModules.vpn
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

          # Programs
          programs.zsh.enable = true;
        }
      )
    ];
  };
}
