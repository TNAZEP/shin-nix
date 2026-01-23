{ lib, ... }:
let
  # Shared packages between darwin and nixos
  commonPackages = pkgs: with pkgs; [
    vim
    wget
    curl
    htop
    btop
    fastfetch
    superfile
    nodejs
  ];

  commonNixSettings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
in
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
    { pkgs, ... }:
    {
      nix.settings = commonNixSettings;

      time.timeZone = "Asia/Tokyo";
      i18n.defaultLocale = "en_GB.UTF-8";
      console.keyMap = "sv-latin1";

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = commonPackages pkgs ++ [
        pkgs.nix-output-monitor
        pkgs.speedtest-cli
      ];
    };

  config.flake.darwinModules.common =
    { pkgs, ... }:
    {
      nix.settings = commonNixSettings;
      time.timeZone = "Asia/Tokyo";
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = commonPackages pkgs;
    };

  config.flake.homeModules.common =
    { ... }:
    {
      programs.pay-respects.enable = true;
    };
}
