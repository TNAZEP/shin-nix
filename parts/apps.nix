{
  flake.nixosModules.apps =
    { config, pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.homeModules.apps =
    { config, pkgs, ... }:
    {
    };
}
