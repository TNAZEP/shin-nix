{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common/home.nix
    ../../modules/hardware/nvidia/home.nix
    ../../modules/roles/desktop/home.nix
    ../../modules/roles/gaming/home.nix
    ../../modules/apps/home.nix
    ../../modules/roles/utilities/home.nix
  ];

  home.username = "tnazep";
  home.homeDirectory = "/home/tnazep";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
  
  # Basic git config
  programs.git = {
    enable = true;
    userName = "TNAZEP";
    userEmail = "jacob@example.com"; # Update this
  };
}
