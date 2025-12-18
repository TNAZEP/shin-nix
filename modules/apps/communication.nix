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
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
    in
    {
      environment.systemPackages = filterAvailable (
        with pkgs;
        [
          vesktop
          element-desktop
        ]
      );
    };
}
