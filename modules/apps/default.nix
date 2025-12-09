{
  flake.nixosModules.apps =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.darwinModules.apps =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.homeModules.apps =
    { ... }:
    {
    };
}
