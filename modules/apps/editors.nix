{ lib, ... }:
let
  # Shared editor/LSP packages for system level
  editorPackages = pkgs: with pkgs; [
    antigravity
    nil
    nixd
    code-cursor
  ];
in
{
  flake.nixosModules.editors =
    { pkgs, ... }:
    {
      environment.systemPackages = editorPackages pkgs;
    };

  flake.darwinModules.editors =
    { pkgs, ... }:
    {
      environment.systemPackages = builtins.filter
        (lib.meta.availableOn pkgs.stdenv.hostPlatform)
        (editorPackages pkgs);
    };

  flake.homeModules.editors =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
      };
    };
}
