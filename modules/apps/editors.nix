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
  flake.homeModules.editors =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
      };
    };
}
