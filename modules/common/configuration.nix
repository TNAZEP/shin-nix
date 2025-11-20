{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Asia/Tokyo"; # Assuming user is in Tokyo based on metadata, can be changed.

  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "sv-latin1";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    curl
    htop
    btop
    fastfetch
  ];
}
