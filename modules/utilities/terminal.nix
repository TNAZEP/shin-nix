{
  flake.nixosModules.terminal =
    { ... }:
    {
      programs.zsh.enable = true;
    };

  flake.homeModules.terminal =
    { config, lib, pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          font.normal.family = "JetBrainsMono Nerd Font";
        };
        theme = "kanagawa_dragon";
      };



      programs.zsh = {
        enable = true;

        initExtra = ''
          source ${./p10k.zsh}
        '';

        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
          ];
        };

        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
      };
    };
}
