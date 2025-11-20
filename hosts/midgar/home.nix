{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}:

{
  imports = [
    ../../modules/common/home.nix
    ../../modules/hardware/nvidia/home.nix
    ../../modules/roles/desktop/home.nix
    ../../modules/roles/gaming/home.nix
    ../../modules/apps/home.nix
    ../../modules/roles/utilities/home.nix
  ];

  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;

    matchBlocks."*" = {
      identityAgent = "~/.1password/agent.sock";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userSettings.name;
        email = userSettings.email;
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEclWROAzXXuA3fE8qIWW55pJLOewedBGS6bT6Sf3xG4";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      init.defaultBranch = "master";
      commit.gpgSign = true;
      gpg.format = "ssh";
    };
  };
}
