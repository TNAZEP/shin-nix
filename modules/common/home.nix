{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # With Oh-My-Zsh:
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" # also requires `programs.git.enable = true;`
      ];
      theme = "robbyrussell";
    };
  };

  programs.pay-respects.enable = true;
}
