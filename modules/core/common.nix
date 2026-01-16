{ lib, config, ... }:
let
  userSettings = config.meta.settings;

  # Shared packages for both NixOS and Darwin
  sharedPackages = pkgs: with pkgs; [
    vim
    wget
    curl
    htop
    btop
    fastfetch
    superfile
    nodejs
  ];

  # Shared nix settings
  sharedNixSettings = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;
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
    lib.recursiveUpdate sharedNixSettings {
      networking.nameservers = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];

      time.timeZone = userSettings.timezone;
      i18n.defaultLocale = userSettings.locale;
      console.keyMap = "sv-latin1";

      environment.systemPackages = (sharedPackages pkgs) ++ (with pkgs; [
        nix-output-monitor
        speedtest-cli
      ]);
    };

  config.flake.darwinModules.common =
    { pkgs, ... }:
    lib.recursiveUpdate sharedNixSettings {
      time.timeZone = userSettings.timezone;
      environment.systemPackages = sharedPackages pkgs;
    };

  config.flake.homeModules.common =
    { ... }:
    {
      programs.pay-respects.enable = true;
    };
}
