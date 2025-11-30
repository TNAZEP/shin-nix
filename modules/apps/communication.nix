{
  flake.nixosModules.communication =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vesktop
        # cinny-desktop # Marked as broken in nixpkgs
      ];
    };

  flake.homeModules.communication =
    { ... }:
    {
    };
}
