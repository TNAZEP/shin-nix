{
  flake.darwinModules.browsers =
    { pkgs, ... }:
    {
      homebrew.casks = [ "firefox" ];
    };
  flake.homeModules.browsers =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # 1Password Manifest
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

        # On Darwin: Install NO package (use Homebrew Firefox), but generate configs.
        # On Linux: Install the Firefox package.
        package = if pkgs.stdenv.isDarwin then null else pkgs.firefox;

        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = sharedSettings;
        };

        # Keep policies for Linux if you want, ignored on Mac if package is null
        policies = lib.mkIf pkgs.stdenv.isLinux {
          DisablePocket = true;
          DisableTelemetry = true;
        };
      };

      # macOS Specific: Manually place the 1Password manifest
      home.file = lib.mkIf pkgs.stdenv.isDarwin {
        "Library/Application Support/Mozilla/NativeMessagingHosts/com.1password.1password.json".text =
          builtins.toJSON onePassManifest;
      };
    };
}
