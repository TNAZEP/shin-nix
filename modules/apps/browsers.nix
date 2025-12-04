{
  flake.nixosModules.browsers =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.firefox ];
    };

  flake.darwinModules.browsers =
    { pkgs, ... }:
    let
      filterAvailable = builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
    in
    {
      environment.systemPackages = filterAvailable [ pkgs.firefox-bin ];
    };

  flake.homeModules.browsers =
    { ... }:
    {
      programs.firefox = {
        enable = true;
        policies = {
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
          FirefoxHome = {
            Search = true;
            Pocket = false;
            Snippets = false;
            TopSites = false;
            Highlights = false;
          };
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
      };
    };
}
