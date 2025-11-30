{
  flake.nixosModules.terminal =
    { ... }:
    {
      programs.zsh.enable = true;
    };

  flake.homeModules.terminal =
    { pkgs, ... }:
    {
      programs.alacritty.enable = true;

      programs.zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
          ];
          theme = "robbyrussell";
        };
      };
    };
}
