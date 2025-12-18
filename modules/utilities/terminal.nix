{ config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosModules.terminal =
    { ... }:
    {
      programs.zsh.enable = true;
    };

  flake.darwinModules.terminal =
    { ... }:
    {
      programs.zsh.enable = true;
      homebrew.casks = [ "1password-cli" ];
    };

  flake.homeModules.terminal =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          font.normal.family = userSettings.font;
        };
        theme = "kanagawa_dragon";
      };

      programs.zsh = {
        enable = true;

        initContent = ''
          source ${./p10k.zsh}
        '';

        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
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
