{
  flake.nixosModules.utilities =
    {
      config,
      pkgs,
      userSettings,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        antigravity
        nixfmt-rfc-style
        hyprshot
        nautilus
        overskride
        blueberry
      ];

      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ userSettings.username ];
      };
    };

  flake.homeModules.utilities =
    { config, pkgs, ... }:
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

      programs.alacritty.enable = true;

      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
      };

      home.packages = with pkgs; [
        zed-editor
        github-desktop
      ];
    };
}
