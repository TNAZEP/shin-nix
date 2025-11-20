{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # With Oh-My-Zsh:
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" # also requires `programs.git.enable = true;`
        "thefuck" # also requires `programs.thefuck.enable = true;`
      ];
      theme = "robbyrussell";
    };
  };
}
