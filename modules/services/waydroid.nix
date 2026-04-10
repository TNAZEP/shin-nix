{
  flake.nixosModules.waydroid =
    { pkgs, ... }:
    {
      virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };
    };
}
