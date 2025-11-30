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

  flake.homeModules.utilities =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
      ];
    };
}
