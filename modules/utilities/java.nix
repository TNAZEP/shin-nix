{ ... }:
{
  flake.nixosModules.java =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        zulu8
        zulu17
        zulu21
        zulu25
      ];

      # Set Java 21 as the default
      programs.java = {
        enable = true;
        package = pkgs.zulu21;
      };
    };

  flake.darwinModules.java =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        zulu8
        zulu17
        zulu21
        zulu25
      ];
    };
}

