{ lib, ... }:
{
  options.meta.settings = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption { type = lib.types.str; };
        name = lib.mkOption { type = lib.types.str; };
        email = lib.mkOption { type = lib.types.str; };
        dotfilesDir = lib.mkOption { type = lib.types.str; };
        theme = lib.mkOption { type = lib.types.str; };
        wm = lib.mkOption { type = lib.types.str; };
        browser = lib.mkOption { type = lib.types.str; };
        term = lib.mkOption { type = lib.types.str; };
        font = lib.mkOption { type = lib.types.str; };
        editor = lib.mkOption { type = lib.types.str; };
      };
    };
    default = {
      username = "tnazep";
      name = "TNAZEP";
      email = "jacob@ennaimi.com";
      dotfilesDir = "/home/tnazep/shin-nix";
      theme = "kanagawa-dragon";
      wm = "hyprland";
      browser = "firefox";
      term = "alacritty";
      font = "JetBrainsMono Nerd Font";
      editor = "codium";
    };
    description = "Global settings for the configuration";
  };
}
