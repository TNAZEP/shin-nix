{ config, ... }:
let
  userSettings = config.meta.settings;

  # Shared utility packages
  utilityPackages = pkgs: with pkgs; [
    nixfmt-rfc-style
  ];

  # Shared 1Password configuration
  shared1PasswordConfig = {
    programs._1password.enable = true;
    programs._1password-gui.enable = true;
  };
in
{
  flake.nixosModules.utilities =
    { pkgs, lib, ... }:
    lib.recursiveUpdate shared1PasswordConfig {
      environment.systemPackages = utilityPackages pkgs;
      programs._1password-gui.polkitPolicyOwners = [ userSettings.username ];
    };

  flake.darwinModules.utilities =
    { pkgs, lib, ... }:
    lib.recursiveUpdate shared1PasswordConfig {
      environment.systemPackages = utilityPackages pkgs;
    };
}
