{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./disko.nix
      ./hardware-configuration.nix
      ../../modules/common/configuration.nix
      ../../modules/hardware/nvidia/configuration.nix
      ../../modules/roles/desktop/configuration.nix
      ../../modules/roles/gaming/configuration.nix
      ../../modules/apps/configuration.nix
      ../../modules/roles/utilities/configuration.nix
    ];

  networking.hostName = "midgar";
  networking.networkmanager.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tnazep = {
    isNormalUser = true;
    description = "TNAZEP";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  
  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
