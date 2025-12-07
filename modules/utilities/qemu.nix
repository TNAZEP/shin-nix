{ config, ... }:
{
  flake.nixosModules.qemu =
    { pkgs, ... }:
    let
      userSettings = config.meta.settings;
    in
    {
      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            swtpm.enable = true;
          };
        };
      };

      users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
      ];
    };
}
