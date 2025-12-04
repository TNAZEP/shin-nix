{
  flake.nixosModules.browsers =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.firefox ];
    };

  flake.darwinModules.browsers =
    { pkgs, ... }:
    {
      homebrew.casks = [ "firefox" ];
    };

  flake.homeModules.browsers =
    { config, lib, pkgs, ... }:
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
        "signon.rememberSignons" = false; # OfferToSaveLogins
        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = true;
        
        "browser.aboutConfig.showWarning" = false;
        "browser.onboarding.enabled" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Pocket
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
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          PasswordManagerEnabled = false;
        };
      };

      home.file = lib.mkIf pkgs.stdenv.isDarwin {
        "Library/Application Support/Mozilla/NativeMessagingHosts/com.1password.1password.json".text = builtins.toJSON onePassManifest;
      };

      home.activation = lib.mkIf pkgs.stdenv.isDarwin {
        linkFirefoxConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
          RUN_PATH="/Applications/Firefox.app"
          MAC_CONFIG="$HOME/Library/Application Support/Firefox"
          HM_CONFIG="$HOME/.mozilla/firefox"

          if [ -d "$RUN_PATH" ]; then
            # If the config folder exists and is NOT a symlink, back it up
            if [ -d "$MAC_CONFIG" ] && [ ! -L "$MAC_CONFIG" ]; then
              echo "Backing up existing Firefox config..."
              mv "$MAC_CONFIG" "$MAC_CONFIG.backup"
            fi

            if [ ! -L "$MAC_CONFIG" ]; then
              echo "Linking Firefox config to Home Manager..."
              ln -s "$HM_CONFIG" "$MAC_CONFIG"
            fi
          fi
        '';
      };
    };
}