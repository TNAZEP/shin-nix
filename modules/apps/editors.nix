{
  flake.nixosModules.editors =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.antigravity ];
    };

  flake.darwinModules.editors =
    { pkgs, ... }:
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
    in
    {
      environment.systemPackages = filterAvailable [ pkgs.antigravity ];
    };

  flake.homeModules.editors =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
      };

      home.packages = [
        pkgs.zed-editor
      ];
    };
}
