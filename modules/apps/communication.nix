{
  flake.nixosModules.communication =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vesktop
        element-desktop
      ];
    };

  flake.darwinModules.communication =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vesktop
        element-desktop
      ];
    };

  flake.homeModules.communication =
    { ... }:
    {
    };
}
