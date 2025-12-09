{
  flake.darwinModules.browsers =
    { ... }:
    {
      homebrew.casks = [ "firefox" ];
    };

  flake.homeModules.browsers =
    {
      lib,
      pkgs,
      ...
    }:
    let
      onePassManifest = {
        name = "com.1password.1password";
        description = "1Password BrowserSupport";
        path = "/Applications/1Password.app/Contents/Library/LoginItems/1Password Browser Helper.app/Contents/MacOS/1Password-BrowserSupport";
        type = "stdio";
        allowed_extensions = [
          "com.1password.1password@extensions.1password.com"
          "2bua8c4s2c"
        ];
      };

      sharedSettings = {
        "extensions.pocket.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "signon.rememberSignons" = false;
        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.onboarding.enabled" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };
    in
    {
      programs.firefox = {
        enable = true;

        package = if pkgs.stdenv.isDarwin then null else pkgs.firefox;

        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = sharedSettings;
        };

        policies = lib.mkIf pkgs.stdenv.isLinux {
          DisablePocket = true;
          DisableTelemetry = true;
        };
      };

      home.file = lib.mkIf pkgs.stdenv.isDarwin {
        "Library/Application Support/Mozilla/NativeMessagingHosts/com.1password.1password.json".text =
          builtins.toJSON onePassManifest;
      };
    };
}
