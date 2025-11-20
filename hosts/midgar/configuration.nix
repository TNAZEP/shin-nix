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
  
  programs = {
    ssh.startAgent = true;
  };

  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    resolved.enable = true;
    flatpak.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;
    # @FIX gnome gcr agent conflicts with programs.ssh.startAgent;
    # gnome.gnome-keyring.enable = true;
    tailscale = {
      enable = true;
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  programs.zsh.enable = true;

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
    bigblue-terminal
  ];

  programs.fuse.userAllowOther = true;

  system.stateVersion = "25.11";
}
