{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs.nerd-fonts; [
        fira-code
        jetbrains-mono
        bigblue-terminal
      ];
    };

  flake.darwinModules.fonts =
    { pkgs, ... }:
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
    in
    {
      fonts.packages = filterAvailable (
        with pkgs.nerd-fonts;
        [
          fira-code
          jetbrains-mono
          bigblue-terminal
        ]
      );
    };
}
