{
  flake.nixosModules.nvidia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hardware.graphics = {
        enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

  flake.homeModules.nvidia =
    { config, pkgs, ... }:
    {
    };
}
