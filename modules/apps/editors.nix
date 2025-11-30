{
  flake.nixosModules.editors =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.antigravity ];
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
