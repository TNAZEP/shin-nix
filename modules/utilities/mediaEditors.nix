{
  flake.nixosModules.mediaEditors =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        davinci-resolve
      ];
    };
}
