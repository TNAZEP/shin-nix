{ config, lib, ... }:
{
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
  };

  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.nixosModules.common =
    {
      config,
      pkgs,
      ...
    }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      time.timeZone = "Asia/Tokyo";

      i18n.defaultLocale = "en_GB.UTF-8";
      console.keyMap = "sv-latin1";

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        htop
        btop
        fastfetch
        superfile
      ];
    };

  config.flake.darwinModules.common =
    {
      config,
      pkgs,
      ...
    }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      time.timeZone = "Asia/Tokyo";

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        htop
        btop
        fastfetch
        superfile
      ];
    };

  config.flake.homeModules.common =
    { config, pkgs, ... }:
    {
      programs.pay-respects.enable = true;
    };
}
