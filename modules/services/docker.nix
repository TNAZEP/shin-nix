{ config, ... }:
{
  flake.nixosModules.docker =
    { pkgs, ... }:
    let
      userSettings = config.meta.settings;
    in
    {
      virtualisation = {
        oci-containers.backend = "docker";
        docker.enable = true;
      };

      users.users.${userSettings.username}.extraGroups = [ "docker" ];

      environment.systemPackages = with pkgs; [
        lazydocker
      ];
    };
}
