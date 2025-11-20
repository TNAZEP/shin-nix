{
  config,
  pkgs,
  antigravity-pkg,
  userSettings,
  ...
}:
let
  antigravityPkgs = import antigravity-pkg {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    zed-editor
    vscodium
    antigravityPkgs.antigravity
    nixfmt-rfc-style
    github-desktop
    alacritty
  ];

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      extraPolicies = {
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
