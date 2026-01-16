{ lib, ... }:
let
  # Shared font packages
  fontPackages = pkgs: with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
    bigblue-terminal
  ];
in
{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts.packages = fontPackages pkgs;
    };

  flake.darwinModules.fonts =
    { pkgs, ... }:
    {
      fonts.packages = builtins.filter
        (lib.meta.availableOn pkgs.stdenv.hostPlatform)
        (fontPackages pkgs);
    };
}
