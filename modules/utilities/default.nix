{
  flake.nixosModules.utilities =
    {
      config,
      pkgs,
      userSettings,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        nixfmt-rfc-style
        hyprshot
        nautilus
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
