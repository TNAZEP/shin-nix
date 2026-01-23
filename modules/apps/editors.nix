{
  flake.nixosModules.editors =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        antigravity
        nil
        nixd
        code-cursor
      ];
    };

  flake.darwinModules.editors =
    { pkgs, ... }:
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
    in
    {
      environment.systemPackages = filterAvailable (with pkgs; [
        antigravity
        nil
        nixd
        code-cursor
      ]);
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
