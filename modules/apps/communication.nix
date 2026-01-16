{ lib, ... }:
let
  # Shared communication packages
  communicationPackages = pkgs: with pkgs; [
    vesktop
    element-desktop
  ];
in
{
  flake.nixosModules.communication =
    { pkgs, ... }:
    {
      environment.systemPackages = communicationPackages pkgs;
    };

  flake.darwinModules.communication =
    { pkgs, ... }:
    {
      environment.systemPackages = builtins.filter
        (lib.meta.availableOn pkgs.stdenv.hostPlatform)
        (communicationPackages pkgs);
    };
}
