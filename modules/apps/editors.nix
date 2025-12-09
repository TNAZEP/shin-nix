{
  flake.nixosModules.editors =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.antigravity
        pkgs.nil
        pkgs.nixd
      ];
    };

  flake.darwinModules.editors =
    { pkgs, ... }:
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
    in
    {
      environment.systemPackages = filterAvailable [
        pkgs.antigravity
        pkgs.nil
        pkgs.nixd
      ];
    };

  flake.homeModules.editors =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
      };

      programs.zed-editor = {
        enable = true;
        extensions = [
          "swift"
          "nix"
          "hyprland"
        ];
        userSettings = {
          features = {
          };
          vim_mode = false;
        };
      };
    };
}
