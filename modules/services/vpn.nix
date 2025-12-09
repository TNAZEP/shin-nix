{
  flake.nixosModules.vpn =
    { pkgs, ... }:
    {
      services.tailscale.enable = true;
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };

  flake.darwinModules.vpn =
    { ... }:
    {
      services.tailscale.enable = true;
      services.mullvad-vpn = {
        enable = true;
        package = pkgs.mullvad-vpn;
      };
    };
}
