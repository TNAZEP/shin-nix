{ lib, ... }:
{
  options.meta.settings = lib.mkOption {
    type = lib.types.submodule {
      options = {
        # User identity
        username = lib.mkOption { type = lib.types.str; };
        name = lib.mkOption { type = lib.types.str; };
        email = lib.mkOption { type = lib.types.str; };

        # Paths
        dotfilesDir = lib.mkOption { type = lib.types.str; };

        # Theme & appearance
        theme = lib.mkOption { type = lib.types.str; };
        font = lib.mkOption { type = lib.types.str; };

        # Default applications
        wm = lib.mkOption { type = lib.types.str; };
        browser = lib.mkOption { type = lib.types.str; };
        term = lib.mkOption { type = lib.types.str; };
        editor = lib.mkOption { type = lib.types.str; };

        # Locale
        timezone = lib.mkOption { type = lib.types.str; };
        locale = lib.mkOption { type = lib.types.str; };
        keyboardLayout = lib.mkOption { type = lib.types.str; };

        # Monitor configuration (used by hyprland/waybar)
        monitors = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule {
            options = {
              output = lib.mkOption { type = lib.types.str; };
              resolution = lib.mkOption { type = lib.types.str; default = "preferred"; };
              position = lib.mkOption { type = lib.types.str; default = "auto"; };
              scale = lib.mkOption { type = lib.types.str; default = "1"; };
              extraArgs = lib.mkOption { type = lib.types.str; default = ""; };
              workspaces = lib.mkOption { type = lib.types.listOf lib.types.int; default = [ ]; };
            };
          });
          default = { };
        };

        # SSH signing key (for git)
        sshSigningKey = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };
    };
    default = {
      username = "tnazep";
      name = "TNAZEP";
      email = "jacob@ennaimi.com";
      dotfilesDir = "/home/tnazep/shin-nix";

      theme = "kanagawa-dragon";
      font = "JetBrainsMono Nerd Font";

      wm = "hyprland";
      browser = "firefox";
      term = "alacritty";
      editor = "codium";

      timezone = "Asia/Tokyo";
      locale = "en_GB.UTF-8";
      keyboardLayout = "se";

      monitors = {
        main = {
          output = "DP-1";
          resolution = "2560x1440@240";
          position = "1920x0";
          scale = "1";
          extraArgs = "bitdepth,10";
          workspaces = [ 1 2 3 4 5 6 7 8 9 10 ];
        };
        secondary = {
          output = "DP-2";
          resolution = "1920x1080@144";
          position = "0x360";
          scale = "1";
          workspaces = [ 11 12 13 14 15 16 17 18 19 20 ];
        };
      };

      sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEclWROAzXXuA3fE8qIWW55pJLOewedBGS6bT6Sf3xG4";
    };
    description = "Global settings for the configuration";
  };
}
