{ config, ... }:
{
  flake.nixosModules.utilities =
    {
      pkgs,
      ...
    }:
    let
      userSettings = config.meta.settings;
    in
    {
      environment.systemPackages = with pkgs; [
        nixfmt-rfc-style
      ];

      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ userSettings.username ];
      };
    };

  flake.darwinModules.utilities =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nixfmt-rfc-style
      ];

      programs._1password.enable = true;
      programs._1password-gui.enable = true;
    };

  flake.homeModules.utilities =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
      ];
    };
}
