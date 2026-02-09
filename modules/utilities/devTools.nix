{
  flake.nixosModules.devTools =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        godot
      ];
    };
}
